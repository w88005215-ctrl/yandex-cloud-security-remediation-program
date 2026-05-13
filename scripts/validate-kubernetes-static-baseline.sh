#!/usr/bin/env bash

echo "YCSEC Phase 8R2 — Kubernetes Static Baseline Validation"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

export PATH="$HOME/.local/bin:$HOME/yandex-cloud/bin:$PATH"

FAIL_COUNT=0
WARN_COUNT=0

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

require_file() {
  file="$1"

  if test -s "$file"; then
    ok "$file"
  else
    fail "$file"
  fi
}

require_cmd() {
  name="$1"

  if command -v "$name" >/dev/null 2>&1; then
    ok "$name -> $(command -v "$name")"
  else
    fail "$name missing"
  fi
}

require_grep() {
  description="$1"
  pattern="$2"
  file="$3"

  if grep -qE "$pattern" "$file"; then
    ok "$description"
  else
    fail "$description"
  fi
}

echo "Tool checks"
require_cmd yq
require_cmd gitleaks
echo

echo "Documentation checks"
require_file docs/ru/kubernetes-security-model.md
require_file docs/en/kubernetes-security-model.md
echo

echo "Manifest presence checks"
MANIFESTS="
kubernetes/namespaces/ycsec-insecure.yaml
kubernetes/namespaces/ycsec-hardened.yaml
kubernetes/insecure-baseline/demo-app-insecure.yaml
kubernetes/hardened/demo-app-hardened.yaml
kubernetes/rbac/ycsec-demo-readonly.yaml
kubernetes/network-policies/default-deny.yaml
kubernetes/network-policies/allow-dns-egress.yaml
kubernetes/network-policies/allow-same-namespace-web.yaml
kubernetes/kyverno-policies/disallow-privileged.yaml
kubernetes/kyverno-policies/require-non-root.yaml
kubernetes/kyverno-policies/require-readonly-rootfs.yaml
kubernetes/kyverno-policies/require-resource-limits.yaml
kubernetes/pod-security/README.md
"

for file in $MANIFESTS; do
  require_file "$file"
done
echo

echo "YAML parse checks"
for file in \
  kubernetes/namespaces/ycsec-insecure.yaml \
  kubernetes/namespaces/ycsec-hardened.yaml \
  kubernetes/insecure-baseline/demo-app-insecure.yaml \
  kubernetes/hardened/demo-app-hardened.yaml \
  kubernetes/rbac/ycsec-demo-readonly.yaml \
  kubernetes/network-policies/default-deny.yaml \
  kubernetes/network-policies/allow-dns-egress.yaml \
  kubernetes/network-policies/allow-same-namespace-web.yaml \
  kubernetes/kyverno-policies/disallow-privileged.yaml \
  kubernetes/kyverno-policies/require-non-root.yaml \
  kubernetes/kyverno-policies/require-readonly-rootfs.yaml \
  kubernetes/kyverno-policies/require-resource-limits.yaml
do
  if yq e '.' "$file" >/dev/null 2>&1; then
    ok "YAML parse: $file"
  else
    fail "YAML parse: $file"
  fi
done
echo

echo "Static baseline scope decision"
ok "Phase 8 is static/offline manifest validation"
ok "kubectl apply is intentionally not used in Phase 8"
ok "kubectl dry-run is intentionally not used as a blocking check in Phase 8"
ok "runtime Kubernetes API validation is deferred to Phase 9"
echo

echo "Insecure baseline expected-risk checks"
require_grep "baseline demonstrates privileged container risk" "privileged: true" kubernetes/insecure-baseline/demo-app-insecure.yaml
require_grep "baseline demonstrates root user risk" "runAsUser: 0" kubernetes/insecure-baseline/demo-app-insecure.yaml
require_grep "baseline demonstrates privilege escalation risk" "allowPrivilegeEscalation: true" kubernetes/insecure-baseline/demo-app-insecure.yaml
require_grep "baseline demonstrates NodePort exposure risk" "type: NodePort" kubernetes/insecure-baseline/demo-app-insecure.yaml
echo

echo "Hardened baseline security checks"
require_grep "hardened namespace enforces restricted Pod Security" "pod-security.kubernetes.io/enforce: restricted" kubernetes/namespaces/ycsec-hardened.yaml
require_grep "hardened workload runs as non-root" "runAsNonRoot: true" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload disables privilege escalation" "allowPrivilegeEscalation: false" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload uses read-only root filesystem" "readOnlyRootFilesystem: true" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload disables privileged mode" "privileged: false" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload defines dropped Linux capabilities" "drop:" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload drops all Linux capabilities" "ALL" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload uses RuntimeDefault seccomp" "RuntimeDefault" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload defines resource requests" "requests:" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened workload defines resource limits" "limits:" kubernetes/hardened/demo-app-hardened.yaml
require_grep "service account token automount disabled" "automountServiceAccountToken: false" kubernetes/hardened/demo-app-hardened.yaml
require_grep "hardened service uses ClusterIP" "type: ClusterIP" kubernetes/hardened/demo-app-hardened.yaml
echo

echo "NetworkPolicy checks"
require_grep "default deny NetworkPolicy declares policyTypes" "policyTypes:" kubernetes/network-policies/default-deny.yaml
require_grep "default deny NetworkPolicy covers ingress" "Ingress" kubernetes/network-policies/default-deny.yaml
require_grep "default deny NetworkPolicy covers egress" "Egress" kubernetes/network-policies/default-deny.yaml
require_grep "DNS egress policy targets kube-system DNS" "kube-system" kubernetes/network-policies/allow-dns-egress.yaml
require_grep "DNS egress policy allows DNS port 53" "port: 53" kubernetes/network-policies/allow-dns-egress.yaml

if grep -q "podSelector:" kubernetes/network-policies/allow-same-namespace-web.yaml; then
  ok "same namespace web policy uses podSelector for same-namespace peer selection"
else
  fail "same namespace web policy must use podSelector for same-namespace peer selection"
fi

if grep -q "namespaceSelector:" kubernetes/network-policies/allow-same-namespace-web.yaml; then
  warn "same namespace web policy contains namespaceSelector; review whether cross-namespace access is intended"
else
  ok "same namespace web policy does not require namespaceSelector"
fi

require_grep "same namespace web policy allows application port 8080" "port: 8080" kubernetes/network-policies/allow-same-namespace-web.yaml
echo

echo "RBAC checks"
require_grep "RBAC Role present" "kind: Role" kubernetes/rbac/ycsec-demo-readonly.yaml
require_grep "RBAC RoleBinding present" "kind: RoleBinding" kubernetes/rbac/ycsec-demo-readonly.yaml
require_grep "RBAC readonly get permission present" "get" kubernetes/rbac/ycsec-demo-readonly.yaml
require_grep "RBAC readonly list permission present" "list" kubernetes/rbac/ycsec-demo-readonly.yaml
require_grep "RBAC readonly watch permission present" "watch" kubernetes/rbac/ycsec-demo-readonly.yaml
echo

echo "Kyverno policy checks"
require_grep "Kyverno privileged policy is ClusterPolicy" "kind: ClusterPolicy" kubernetes/kyverno-policies/disallow-privileged.yaml
require_grep "Kyverno privileged policy checks privileged containers" "privileged: false" kubernetes/kyverno-policies/disallow-privileged.yaml
require_grep "Kyverno non-root policy checks runAsNonRoot" "runAsNonRoot: true" kubernetes/kyverno-policies/require-non-root.yaml
require_grep "Kyverno readonly rootfs policy checks readOnlyRootFilesystem" "readOnlyRootFilesystem: true" kubernetes/kyverno-policies/require-readonly-rootfs.yaml
require_grep "Kyverno resource policy checks resource requirements" "resources:" kubernetes/kyverno-policies/require-resource-limits.yaml
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
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && fail "kubeconfig-like files found" || ok "No kubeconfig files"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && fail "key/token-like files found" || ok "No key/token-like files"
echo

echo "Cloud cost control"
ok "No Yandex Cloud resources created in this phase"
ok "No promo code activation in this phase"
ok "No terraform apply executed in this phase"
ok "No kubectl apply to a real cluster executed in this phase"
ok "No Managed Kubernetes created in this phase"
ok "No Compute nodes created in this phase"
ok "No LoadBalancer created in this phase"
ok "No public IP created in this phase"
echo

echo "Validation summary"
if test "$FAIL_COUNT" -eq 0; then
  ok "Kubernetes static baseline validation completed without blocking failures"
else
  fail "Kubernetes static baseline validation has $FAIL_COUNT blocking failure(s)"
fi

if test "$WARN_COUNT" -eq 0; then
  ok "No warning findings"
else
  warn "Kubernetes static baseline validation has $WARN_COUNT warning finding(s)"
fi

test "$FAIL_COUNT" -eq 0
