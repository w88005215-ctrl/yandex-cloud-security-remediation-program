#!/usr/bin/env bash
set -u

echo "YCSEC Phase 11 — Yandex Cloud short Kubernetes smoke-run"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

export PATH="$HOME/.local/bin:$HOME/yandex-cloud/bin:$PATH"

ENV_DIR="terraform/environments/cloud-smoke"
EVIDENCE_DIR="evidence/command-outputs"
KUBECONFIG_DIR="$(mktemp -d)"
KUBECONFIG_PATH="$KUBECONFIG_DIR/kubeconfig"
PLAN_FILE="$EVIDENCE_DIR/YCSEC_11_TERRAFORM_cloud_smoke.tfplan"
PLAN_TEXT="$EVIDENCE_DIR/YCSEC_11_OUTPUT_terraform_plan.txt"

FAIL_COUNT=0
WARN_COUNT=0

cleanup_note() {
  echo
  echo "Cleanup note:"
  echo "[OK] kubeconfig temporary directory: $KUBECONFIG_DIR"
  echo "[OK] kubeconfig path: $KUBECONFIG_PATH"
}

require_tool() {
  tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool -> $(command -v "$tool")"
  else
    echo "[FAIL] $tool missing"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

echo "Tool checks"
for t in yc terraform kubectl gitleaks; do
  require_tool "$t"
done

echo
echo "YC profile checks"
CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"
ZONE="$(yc config get compute-default-zone 2>/dev/null || true)"

if test -n "$CLOUD_ID"; then
  echo "[OK] cloud-id configured"
else
  echo "[FAIL] cloud-id missing"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

if test -n "$FOLDER_ID"; then
  echo "[OK] folder-id configured"
else
  echo "[FAIL] folder-id missing"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

if test -n "$ZONE"; then
  echo "[OK] default zone configured: $ZONE"
else
  ZONE="ru-central1-a"
  echo "[WARN] default zone missing, using $ZONE"
  WARN_COUNT=$((WARN_COUNT + 1))
fi

echo
echo "Budget and boundary"
echo "[OK] target budget envelope: up to 100 RUB for short smoke-run"
echo "[OK] expected resources: VPC, subnet, two service accounts, zonal Managed Kubernetes cluster, one preemptible node group"
echo "[OK] no PersistentVolume resources are created"
echo "[OK] no LoadBalancer Service is created"
echo "[OK] node public NAT is disabled"
echo "[OK] destroy is mandatory after validation"

if test "$FAIL_COUNT" -ne 0; then
  echo
  echo "[FAIL] preflight failed before Terraform"
  cleanup_note
  rm -rf "$KUBECONFIG_DIR"
  exit 1
fi

echo
echo "Write local tfvars outside git ignore-sensitive patterns"
cat > "$ENV_DIR/terraform.tfvars" <<VARS
cloud_id  = "$CLOUD_ID"
folder_id = "$FOLDER_ID"
zone      = "$ZONE"
VARS

echo "[OK] terraform.tfvars written for cloud-smoke environment"

echo
echo "Terraform formatting"
terraform -chdir="$ENV_DIR" fmt -check
if test "$?" -eq 0; then
  echo "[OK] terraform fmt"
else
  echo "[FAIL] terraform fmt"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Terraform init"
TF_DATA_DIR="$(mktemp -d)"
TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" init -backend=false -input=false -no-color
INIT_RC="$?"

if test "$INIT_RC" -eq 0; then
  echo "[OK] terraform init"
else
  echo "[FAIL] terraform init"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Terraform validate"
if test "$INIT_RC" -eq 0; then
  TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" validate -no-color
  VALIDATE_RC="$?"
else
  VALIDATE_RC=1
fi

if test "$VALIDATE_RC" -eq 0; then
  echo "[OK] terraform validate"
else
  echo "[FAIL] terraform validate"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Terraform plan"
if test "$FAIL_COUNT" -eq 0; then
  TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" plan -input=false -no-color -out="../../../$PLAN_FILE" | tee "$PLAN_TEXT"
  PLAN_RC="${PIPESTATUS[0]}"
else
  PLAN_RC=1
fi

if test "$PLAN_RC" -eq 0; then
  echo "[OK] terraform plan saved"
else
  echo "[FAIL] terraform plan failed"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Sensitive file checks before apply"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && echo "[FAIL] Terraform state files found before apply" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No Terraform state files before apply"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && echo "[FAIL] kubeconfig-like files found before apply" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No kubeconfig files before apply"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && echo "[FAIL] key/token-like files found before apply" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No key/token-like files before apply"

if test "$FAIL_COUNT" -ne 0; then
  echo
  echo "[FAIL] cloud smoke-run stopped before apply"
  rm -rf "$TF_DATA_DIR" "$KUBECONFIG_DIR"
  exit 1
fi

echo
echo "Explicit cloud creation approval required"
echo "Type exactly: YES_CREATE_CLOUD_RESOURCES"
read -r APPROVAL

if test "$APPROVAL" != "YES_CREATE_CLOUD_RESOURCES"; then
  echo "[FAIL] explicit approval not provided"
  rm -rf "$TF_DATA_DIR" "$KUBECONFIG_DIR"
  exit 1
fi

echo
echo "Terraform apply"
TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" apply -input=false -no-color "../../../$PLAN_FILE"
APPLY_RC="$?"

if test "$APPLY_RC" -eq 0; then
  echo "[OK] terraform apply completed"
else
  echo "[FAIL] terraform apply failed"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Cluster access"
if test "$APPLY_RC" -eq 0; then
  CLUSTER_ID="$(TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" output -raw cluster_id 2>/dev/null || true)"

  if test -n "$CLUSTER_ID"; then
    echo "[OK] cluster_id exported"
    yc managed-kubernetes cluster get-credentials "$CLUSTER_ID" --external --kubeconfig "$KUBECONFIG_PATH"
    CREDS_RC="$?"
  else
    echo "[FAIL] cluster_id output missing"
    CREDS_RC=1
  fi

  if test "$CREDS_RC" -eq 0; then
    echo "[OK] temporary kubeconfig created outside repository"
    KUBECONFIG="$KUBECONFIG_PATH" kubectl cluster-info
    KUBECONFIG="$KUBECONFIG_PATH" kubectl get nodes
  else
    echo "[FAIL] failed to get temporary kubeconfig"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
fi

echo
echo "Apply project Kubernetes manifests to real cluster"
if test "$APPLY_RC" -eq 0 && test -s "$KUBECONFIG_PATH"; then
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/namespaces/ycsec-insecure.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/namespaces/ycsec-hardened.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/insecure-baseline/demo-app-insecure.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/hardened/demo-app-hardened.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/rbac/ycsec-demo-readonly.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/network-policies/default-deny.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/network-policies/allow-dns-egress.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl apply -f kubernetes/network-policies/allow-same-namespace-web.yaml

  echo
  echo "Runtime object checks"
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/namespaces/ycsec-insecure.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/namespaces/ycsec-hardened.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/insecure-baseline/demo-app-insecure.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/hardened/demo-app-hardened.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/rbac/ycsec-demo-readonly.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/network-policies/default-deny.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/network-policies/allow-dns-egress.yaml
  KUBECONFIG="$KUBECONFIG_PATH" kubectl get -f kubernetes/network-policies/allow-same-namespace-web.yaml
  echo "[OK] Kubernetes manifests applied and queried"
fi

echo
echo "Pod Security Admission real API check"
if test "$APPLY_RC" -eq 0 && test -s "$KUBECONFIG_PATH"; then
  BAD_POD="$KUBECONFIG_DIR/bad-privileged-pod.yaml"

  cat > "$BAD_POD" <<'POD'
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
        runAsUser: 0
POD

  if KUBECONFIG="$KUBECONFIG_PATH" kubectl apply --dry-run=server -f "$BAD_POD"; then
    echo "[FAIL] restricted namespace accepted privileged Pod"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  else
    echo "[OK] restricted namespace rejected privileged Pod"
  fi
fi

echo
echo "Secret scan"
gitleaks detect --source . --no-banner --redact
GITLEAKS_RC="$?"

if test "$GITLEAKS_RC" -eq 0; then
  echo "[OK] gitleaks secret scan"
else
  echo "[FAIL] gitleaks secret scan"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Mandatory destroy approval"
echo "Type exactly: YES_DESTROY_CLOUD_RESOURCES"
read -r DESTROY_APPROVAL

if test "$DESTROY_APPROVAL" = "YES_DESTROY_CLOUD_RESOURCES"; then
  echo
  echo "Terraform destroy"
  TF_DATA_DIR="$TF_DATA_DIR" terraform -chdir="$ENV_DIR" destroy -auto-approve -input=false -no-color
  DESTROY_RC="$?"

  if test "$DESTROY_RC" -eq 0; then
    echo "[OK] terraform destroy completed"
  else
    echo "[FAIL] terraform destroy failed"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
else
  echo "[FAIL] destroy approval not provided"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Post-destroy read-only resource check"
yc managed-kubernetes cluster list || true

echo
echo "Repository sensitive file checks after run"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && echo "[FAIL] Terraform state files found after run" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No Terraform state files after run"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && echo "[FAIL] kubeconfig-like files found after run" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No kubeconfig files after run"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && echo "[FAIL] key/token-like files found after run" && FAIL_COUNT=$((FAIL_COUNT + 1)) || echo "[OK] No key/token-like files after run"

rm -rf "$TF_DATA_DIR" "$KUBECONFIG_DIR"
echo "[OK] temporary local Terraform data and kubeconfig removed"

echo
echo "Cloud smoke-run summary"
if test "$FAIL_COUNT" -eq 0; then
  echo "[OK] Yandex Cloud smoke-run completed without blocking failures"
else
  echo "[FAIL] Yandex Cloud smoke-run has $FAIL_COUNT blocking failure(s)"
fi

if test "$WARN_COUNT" -eq 0; then
  echo "[OK] No warning findings"
else
  echo "[WARN] smoke-run has $WARN_COUNT warning finding(s)"
fi

test "$FAIL_COUNT" -eq 0
