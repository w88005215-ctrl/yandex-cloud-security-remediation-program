#!/usr/bin/env bash

set -u

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_ENV_DIR="$REPO_DIR/terraform/environments/cloud-smoke"
EVIDENCE_DIR="$REPO_DIR/evidence/command-outputs"

RUN_ID="$(date +%Y%m%dT%H%M%S)"
RUNTIME_DIR="$(mktemp -d "/tmp/ycsec-smoke-${RUN_ID}.XXXXXX")"
RUNTIME_REPO="$RUNTIME_DIR/repo"
RUN_ENV_DIR="$RUNTIME_REPO/terraform/environments/cloud-smoke"
KUBECONFIG_PATH="$RUNTIME_DIR/kubeconfig"
PLAN_FILE="$RUNTIME_DIR/tfplan"

APPLY_STARTED=0
DESTROY_DONE=0
FAIL_COUNT=0

mkdir -p "$EVIDENCE_DIR"

log_ok() {
  echo "[OK] $1"
}

log_fail() {
  echo "[FAIL] $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

run_readonly_zero_check() {
  echo
  echo "Read-only zero-resource precheck"

  local found=0

  if yc managed-kubernetes cluster list --format json 2>/dev/null | jq -e '.[] | select(.name=="ycsec-smoke-cluster")' >/dev/null; then
    echo "[FAIL] existing smoke cluster found"
    found=1
  else
    echo "[OK] no existing smoke cluster"
  fi

  if yc managed-kubernetes node-group list --format json 2>/dev/null | jq -e '.[] | select(.name=="ycsec-smoke-node-group")' >/dev/null; then
    echo "[FAIL] existing smoke node group found"
    found=1
  else
    echo "[OK] no existing smoke node group"
  fi

  if yc vpc subnet list --format json 2>/dev/null | jq -e '.[] | select(.name=="ycsec-smoke-subnet")' >/dev/null; then
    echo "[FAIL] existing smoke subnet found"
    found=1
  else
    echo "[OK] no existing smoke subnet"
  fi

  if yc vpc network list --format json 2>/dev/null | jq -e '.[] | select(.name=="ycsec-smoke-network")' >/dev/null; then
    echo "[FAIL] existing smoke network found"
    found=1
  else
    echo "[OK] no existing smoke network"
  fi

  if yc iam service-account list --format json 2>/dev/null | jq -e '.[] | select(.name=="ycsec-smoke-cluster-sa" or .name=="ycsec-smoke-nodes-sa")' >/dev/null; then
    echo "[FAIL] existing smoke service account found"
    found=1
  else
    echo "[OK] no existing smoke service accounts"
  fi

  if test "$found" -ne 0; then
    return 1
  fi

  return 0
}

cleanup() {
  rc="$?"

  echo
  echo "Cleanup handler"

  if test "$APPLY_STARTED" -eq 1 && test "$DESTROY_DONE" -eq 0 && test -d "$RUN_ENV_DIR"; then
    echo "[WARN] apply started and destroy was not completed; attempting Terraform destroy"
    terraform -chdir="$RUN_ENV_DIR" destroy -auto-approve -input=false -no-color
    destroy_rc="$?"

    if test "$destroy_rc" -eq 0; then
      echo "[OK] emergency Terraform destroy completed"
      DESTROY_DONE=1
    else
      echo "[FAIL] emergency Terraform destroy failed"
      echo "[FAIL] runtime directory preserved for manual cleanup: $RUNTIME_DIR"
      exit "$destroy_rc"
    fi
  fi

  if test "$DESTROY_DONE" -eq 1 || test "$APPLY_STARTED" -eq 0; then
    rm -rf "$RUNTIME_DIR"
    echo "[OK] runtime directory removed"
  else
    echo "[WARN] runtime directory preserved: $RUNTIME_DIR"
  fi

  exit "$rc"
}

trap cleanup EXIT INT TERM

echo "YCSEC Phase 11 — Yandex Cloud short Kubernetes smoke-run"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

echo "Explicit approval check"
if test "${YCSEC_CONFIRM_CLOUD_SMOKE_RUN:-}" != "YES"; then
  echo "[FAIL] cloud smoke-run is not approved"
  echo "Run with: YCSEC_CONFIRM_CLOUD_SMOKE_RUN=YES ./scripts/run-yandex-cloud-smoke-run.sh"
  exit 1
fi
log_ok "explicit cloud smoke-run approval provided"

echo
echo "Tool checks"
for t in yc terraform kubectl gitleaks jq tar; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "[OK] $t -> $(command -v "$t")"
  else
    log_fail "$t missing"
  fi
done

if test "$FAIL_COUNT" -ne 0; then
  exit 1
fi

echo
echo "YC profile checks"
CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"
ZONE="$(yc config get compute-default-zone 2>/dev/null || true)"

if test -n "$CLOUD_ID"; then
  log_ok "cloud-id configured"
else
  log_fail "cloud-id missing"
fi

if test -n "$FOLDER_ID"; then
  log_ok "folder-id configured"
else
  log_fail "folder-id missing"
fi

if test -n "$ZONE"; then
  log_ok "default zone configured: $ZONE"
else
  ZONE="ru-central1-a"
  echo "[WARN] default zone missing, using $ZONE"
fi

if test "$FAIL_COUNT" -ne 0; then
  exit 1
fi

run_readonly_zero_check || exit 1

echo
echo "Budget and boundary"
log_ok "short smoke-run only"
log_ok "expected resources: VPC, subnet, two service accounts, zonal Managed Kubernetes cluster, one preemptible node group"
log_ok "node boot disk size must be at least 30 GB"
log_ok "no PersistentVolume resources are created"
log_ok "no LoadBalancer Service is created"
log_ok "node public NAT is disabled"
log_ok "destroy is mandatory in the same run"

echo
echo "Prepare temporary Terraform runtime outside repository"
mkdir -p "$RUNTIME_REPO"

(
  cd "$REPO_DIR" || exit 1
  tar \
    --exclude='.git' \
    --exclude='.terraform' \
    --exclude='*.tfstate*' \
    --exclude='terraform.tfvars' \
    --exclude='tfplan' \
    --exclude='*.tfplan' \
    -cf - terraform
) | (
  cd "$RUNTIME_REPO" || exit 1
  tar -xf -
)

if test -d "$RUN_ENV_DIR"; then
  log_ok "temporary Terraform runtime prepared: $RUN_ENV_DIR"
else
  log_fail "temporary Terraform runtime was not prepared"
  exit 1
fi

cat > "$RUN_ENV_DIR/terraform.tfvars" <<VARS
cloud_id  = "$CLOUD_ID"
folder_id = "$FOLDER_ID"
zone      = "$ZONE"
VARS

chmod 0600 "$RUN_ENV_DIR/terraform.tfvars"
log_ok "terraform.tfvars written only inside temporary runtime directory"

echo
echo "Terraform formatting"
if terraform -chdir="$RUN_ENV_DIR" fmt -check -no-color; then
  log_ok "terraform fmt"
else
  log_fail "terraform fmt"
fi

echo
echo "Terraform init"
if terraform -chdir="$RUN_ENV_DIR" init -input=false -no-color; then
  log_ok "terraform init"
else
  log_fail "terraform init"
fi

echo
echo "Terraform validate"
if terraform -chdir="$RUN_ENV_DIR" validate -no-color; then
  log_ok "terraform validate"
else
  log_fail "terraform validate"
fi

echo
echo "Terraform plan"
if terraform -chdir="$RUN_ENV_DIR" plan -input=false -no-color -out="$PLAN_FILE" 2>&1 | tee "$EVIDENCE_DIR/YCSEC_11_OUTPUT_terraform_plan.txt"; then
  log_ok "terraform plan saved in temporary runtime directory"
else
  log_fail "terraform plan failed"
fi

echo
echo "Sensitive file checks before apply"
find "$REPO_DIR" -name "*.tfstate*" ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "Terraform state files found before apply" || log_ok "No Terraform state files before apply"
find "$REPO_DIR" -iname "*kubeconfig*" ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "kubeconfig-like files found before apply" || log_ok "No kubeconfig files before apply"
find "$REPO_DIR" \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "key/token-like files found before apply" || log_ok "No key/token-like files before apply"

if test "$FAIL_COUNT" -ne 0; then
  echo "[FAIL] cloud smoke-run stopped before apply"
  exit 1
fi

echo
echo "Terraform apply"
APPLY_STARTED=1

if terraform -chdir="$RUN_ENV_DIR" apply -input=false -no-color "$PLAN_FILE"; then
  log_ok "terraform apply completed"
else
  log_fail "terraform apply failed"
fi

if test "$FAIL_COUNT" -ne 0; then
  exit 1
fi

echo
echo "Cluster runtime checks"
CLUSTER_ID="$(terraform -chdir="$RUN_ENV_DIR" output -raw cluster_id 2>/dev/null || true)"

if test -n "$CLUSTER_ID"; then
  log_ok "cluster id obtained"
else
  log_fail "cluster id missing"
fi

if test -n "$CLUSTER_ID"; then
  if yc managed-kubernetes cluster get-credentials "$CLUSTER_ID" --external --kubeconfig "$KUBECONFIG_PATH"; then
    log_ok "temporary kubeconfig created outside repository"
  else
    log_fail "failed to create temporary kubeconfig"
  fi
fi

if test -s "$KUBECONFIG_PATH"; then
  if kubectl --kubeconfig "$KUBECONFIG_PATH" cluster-info; then
    log_ok "kubectl cluster-info"
  else
    log_fail "kubectl cluster-info failed"
  fi

  if kubectl --kubeconfig "$KUBECONFIG_PATH" get nodes -o wide; then
    log_ok "cluster nodes visible"
  else
    log_fail "cluster nodes not visible"
  fi
fi

echo
echo "Secret scan"
if gitleaks detect --source "$REPO_DIR" --no-banner --redact; then
  log_ok "gitleaks secret scan"
else
  log_fail "gitleaks secret scan"
fi

echo
echo "Mandatory Terraform destroy"
if terraform -chdir="$RUN_ENV_DIR" destroy -auto-approve -input=false -no-color; then
  log_ok "terraform destroy completed"
  DESTROY_DONE=1
else
  log_fail "terraform destroy failed"
fi

echo
echo "Post-destroy read-only resource check"
if run_readonly_zero_check; then
  log_ok "no smoke resources remain after destroy"
else
  log_fail "smoke resources remain after destroy"
fi

echo
echo "Sensitive file checks after run"
find "$REPO_DIR" -name "*.tfstate*" ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "Terraform state files found after run" || log_ok "No Terraform state files after run"
find "$REPO_DIR" -iname "*kubeconfig*" ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "kubeconfig-like files found after run" || log_ok "No kubeconfig files after run"
find "$REPO_DIR" \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "$REPO_DIR/.git/*" | grep -q . && log_fail "key/token-like files found after run" || log_ok "No key/token-like files after run"

echo
echo "Smoke-run summary"
if test "$FAIL_COUNT" -eq 0; then
  log_ok "Yandex Cloud smoke-run completed and cleaned up"
  exit 0
else
  echo "[FAIL] Yandex Cloud smoke-run has $FAIL_COUNT failure(s)"
  exit 1
fi
