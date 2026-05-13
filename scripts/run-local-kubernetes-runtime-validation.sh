#!/usr/bin/env bash

echo "YCSEC Phase 9R — Local Kubernetes Runtime Validation"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

export PATH="$HOME/.local/bin:$HOME/yandex-cloud/bin:$PATH"

FAIL_COUNT=0
WARN_COUNT=0
CLUSTER_READY=0
CLUSTER_CREATE_ATTEMPTED=0
CLEANUP_DONE=0

CLUSTER_NAME="ycsec-runtime-$(date +%s)"
RUNTIME_DIR="$(mktemp -d)"
RUNTIME_KUBECONFIG="$RUNTIME_DIR/kubeconfig"

ok() {
  echo "[OK] $1"
}

warn() {
  echo "[WARN] $1"
  WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

cleanup_cluster() {
  if test "$CLEANUP_DONE" -eq 1; then
    return 0
  fi

  echo
  echo "Cleanup"

  if test "$CLUSTER_CREATE_ATTEMPTED" -eq 1; then
    KIND_EXPERIMENTAL_PROVIDER=podman kind delete cluster --name "$CLUSTER_NAME" || warn "kind cluster cleanup returned non-zero"
    ok "temporary kind cluster cleanup attempted: $CLUSTER_NAME"
  else
    ok "no kind cluster creation was attempted"
  fi

  rm -rf "$RUNTIME_DIR"
  ok "temporary kubeconfig directory removed"

  CLEANUP_DONE=1
}

trap cleanup_cluster EXIT

require_cmd() {
  name="$1"

  if command -v "$name" >/dev/null 2>&1; then
    ok "$name -> $(command -v "$name")"
  else
    fail "$name missing"
  fi
}

run_kubectl() {
  kubectl --kubeconfig "$RUNTIME_KUBECONFIG" "$@"
}

apply_manifest() {
  title="$1"
  file="$2"

  echo
  echo "Apply: $title"

  if run_kubectl apply -f "$file"; then
    ok "$title applied"
  else
    fail "$title apply failed"
  fi
}

verify_manifest_objects() {
  title="$1"
  file="$2"

  echo
  echo "Verify objects from manifest: $title"

  if run_kubectl get -f "$file"; then
    ok "$title objects exist"
  else
    fail "$title objects missing"
  fi
}

echo "Tool checks"
require_cmd kind
require_cmd podman
require_cmd kubectl
require_cmd gitleaks
echo

echo "Runtime safety"
ok "temporary cluster name: $CLUSTER_NAME"
ok "temporary kubeconfig is outside repository: $RUNTIME_KUBECONFIG"
ok "global kubeconfig is not used for validation"
echo

if test "$FAIL_COUNT" -eq 0; then
  echo "Create temporary local kind cluster"

  CLUSTER_CREATE_ATTEMPTED=1

  if KIND_EXPERIMENTAL_PROVIDER=podman kind create cluster \
    --name "$CLUSTER_NAME" \
    --kubeconfig "$RUNTIME_KUBECONFIG" \
    --wait 180s; then
    CLUSTER_READY=1
    ok "temporary kind cluster created"
  else
    fail "temporary kind cluster creation failed"
  fi
fi

if test "$CLUSTER_READY" -eq 1; then
  echo
  echo "Cluster API checks"

  if run_kubectl cluster-info; then
    ok "kubectl cluster-info"
  else
    fail "kubectl cluster-info"
  fi

  if run_kubectl version --client=true; then
    ok "kubectl client version"
  else
    fail "kubectl client version"
  fi

  if run_kubectl get nodes; then
    ok "cluster nodes are visible"
  else
    fail "cluster nodes are not visible"
  fi
fi

if test "$CLUSTER_READY" -eq 1; then
  echo
  echo "Apply namespaces"

  apply_manifest "insecure namespace" "kubernetes/namespaces/ycsec-insecure.yaml"
  apply_manifest "hardened namespace" "kubernetes/namespaces/ycsec-hardened.yaml"
fi

if test "$CLUSTER_READY" -eq 1; then
  echo
  echo "Apply workloads and policies"

  apply_manifest "insecure baseline" "kubernetes/insecure-baseline/demo-app-insecure.yaml"
  apply_manifest "hardened workload" "kubernetes/hardened/demo-app-hardened.yaml"
  apply_manifest "RBAC" "kubernetes/rbac/ycsec-demo-readonly.yaml"
  apply_manifest "default deny NetworkPolicy" "kubernetes/network-policies/default-deny.yaml"
  apply_manifest "DNS egress NetworkPolicy" "kubernetes/network-policies/allow-dns-egress.yaml"
  apply_manifest "same namespace web NetworkPolicy" "kubernetes/network-policies/allow-same-namespace-web.yaml"
fi

if test "$CLUSTER_READY" -eq 1; then
  echo
  echo "Runtime object checks"

  verify_manifest_objects "insecure namespace" "kubernetes/namespaces/ycsec-insecure.yaml"
  verify_manifest_objects "hardened namespace" "kubernetes/namespaces/ycsec-hardened.yaml"
  verify_manifest_objects "insecure baseline" "kubernetes/insecure-baseline/demo-app-insecure.yaml"
  verify_manifest_objects "hardened workload" "kubernetes/hardened/demo-app-hardened.yaml"
  verify_manifest_objects "RBAC" "kubernetes/rbac/ycsec-demo-readonly.yaml"
  verify_manifest_objects "default deny NetworkPolicy" "kubernetes/network-policies/default-deny.yaml"
  verify_manifest_objects "DNS egress NetworkPolicy" "kubernetes/network-policies/allow-dns-egress.yaml"
  verify_manifest_objects "same namespace web NetworkPolicy" "kubernetes/network-policies/allow-same-namespace-web.yaml"
fi

if test "$CLUSTER_READY" -eq 1; then
  echo
  echo "Pod Security Admission runtime check"

  BAD_POD="$RUNTIME_DIR/bad-privileged-pod.yaml"

  cat > "$BAD_POD" <<'BADPOD'
apiVersion: v1
kind: Pod
metadata:
  name: ycsec-bad-privileged-pod
  namespace: ycsec-hardened
spec:
  containers:
    - name: pause
      image: registry.k8s.io/pause:3.10
      securityContext:
        privileged: true
        allowPrivilegeEscalation: true
        runAsUser: 0
BADPOD

  BAD_POD_OUTPUT="$RUNTIME_DIR/bad-pod-check.out"

  if run_kubectl apply --dry-run=server -f "$BAD_POD" >"$BAD_POD_OUTPUT" 2>&1; then
    cat "$BAD_POD_OUTPUT"
    fail "restricted namespace did not reject privileged Pod"
  else
    cat "$BAD_POD_OUTPUT"
    ok "restricted namespace rejected privileged Pod"
  fi
fi

echo
echo "Secret scan"

if gitleaks detect --source . --no-banner --redact; then
  ok "gitleaks secret scan"
else
  fail "gitleaks secret scan"
fi

echo
echo "Sensitive file checks"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && fail "Terraform state files found" || ok "No Terraform state files"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && fail "kubeconfig-like files found in repository" || ok "No kubeconfig files in repository"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && fail "key/token-like files found" || ok "No key/token-like files"

echo
echo "Local runtime boundary"
ok "validation used temporary local kind cluster"
ok "validation used temporary kubeconfig outside repository"
ok "no Yandex Cloud command is required for this phase"
ok "no terraform apply is required for this phase"

cleanup_cluster
trap - EXIT

echo
echo "Runtime validation summary"

if test "$FAIL_COUNT" -eq 0; then
  ok "local Kubernetes runtime validation completed without blocking failures"
else
  echo "[FAIL] local Kubernetes runtime validation has $FAIL_COUNT blocking failure(s)"
fi

if test "$WARN_COUNT" -eq 0; then
  ok "No warning findings"
else
  echo "[WARN] local Kubernetes runtime validation has $WARN_COUNT warning finding(s)"
fi

test "$FAIL_COUNT" -eq 0
