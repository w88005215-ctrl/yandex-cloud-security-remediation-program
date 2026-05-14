#!/usr/bin/env bash

echo "YCSEC Phase 12.8 — Bootstrap/OIDC/Audit controlled cloud-run"
echo "Date: $(date -Is)"
echo "Qube: $(hostname)"
echo

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

need_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1 -> $(command -v "$1")"
  else
    fail "missing tool: $1"
  fi
}

echo "Explicit approval check"
if test "${YCSEC_CONFIRM_BOOTSTRAP_CLOUD_RUN:-}" = "YES"; then
  ok "explicit bootstrap cloud-run approval provided"
else
  fail "set YCSEC_CONFIRM_BOOTSTRAP_CLOUD_RUN=YES to allow paid cloud actions"
fi

echo
echo "Required GitHub OIDC scope variables"
if test -n "${YCSEC_GITHUB_OWNER:-}"; then
  ok "YCSEC_GITHUB_OWNER provided"
else
  fail "YCSEC_GITHUB_OWNER is required"
fi

if test -n "${YCSEC_GITHUB_REPO:-}"; then
  ok "YCSEC_GITHUB_REPO provided"
else
  fail "YCSEC_GITHUB_REPO is required"
fi

YCSEC_GITHUB_BRANCH="${YCSEC_GITHUB_BRANCH:-main}"
ok "GitHub branch scope: ${YCSEC_GITHUB_BRANCH}"

echo
echo "Tool checks"
for tool in yc terraform jq gitleaks tar grep find sed awk; do
  need_cmd "$tool"
done

echo
echo "YC profile checks"
YC_CLOUD_ID_VALUE="$(yc config get cloud-id 2>/dev/null || true)"
YC_FOLDER_ID_VALUE="$(yc config get folder-id 2>/dev/null || true)"
YC_ZONE_VALUE="$(yc config get compute-default-zone 2>/dev/null || true)"
YC_TOKEN_VALUE="$(yc iam create-token 2>/dev/null || true)"

if test -n "$YC_CLOUD_ID_VALUE"; then
  ok "cloud-id configured"
else
  fail "cloud-id is not configured"
fi

if test -n "$YC_FOLDER_ID_VALUE"; then
  ok "folder-id configured"
else
  fail "folder-id is not configured"
fi

if test -n "$YC_ZONE_VALUE"; then
  ok "default zone configured"
else
  YC_ZONE_VALUE="ru-central1-a"
  warn "default zone missing, using ru-central1-a"
fi

if test -n "$YC_TOKEN_VALUE"; then
  ok "short-lived IAM token created for Terraform provider"
else
  fail "IAM token was not created"
fi

if test "$FAIL_COUNT" -ne 0; then
  echo
  echo "[FAIL] bootstrap prerequisites failed"
  echo "[ACTION] fix failed checks before running cloud actions"
  exit 0
fi

echo
echo "Bootstrap boundary"
ok "expected resources: service accounts, GitHub OIDC federation, federated credential, Container Registry, Object Storage bucket, Audit Trails trail"
ok "no Kubernetes cluster is created in this phase"
ok "no Compute instance is created in this phase"
ok "no Network Load Balancer is created in this phase"
ok "Terraform runtime is created outside repository"
ok "Terraform state must not be stored in repository"

echo
echo "Prepare temporary Terraform runtime outside repository"
RUN_ID="$(date -u +%Y%m%dT%H%M%S)"
RUN_ID_LOWER="$(printf "%s" "$RUN_ID" | tr '[:upper:]' '[:lower:]')"
SAFE_FOLDER_ID="$(printf '%s' "$YC_FOLDER_ID_VALUE" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')"
AUDIT_BUCKET_NAME="${YCSEC_BOOTSTRAP_BUCKET_NAME:-ycsec-audit-${SAFE_FOLDER_ID}-${RUN_ID}}"
DESTROY_AFTER_RUN="${YCSEC_BOOTSTRAP_DESTROY_AFTER_RUN:-YES}"

RUNTIME_ROOT="$(mktemp -d "/tmp/ycsec-bootstrap-${RUN_ID}.XXXXXX")"
RUNTIME_DIR="$RUNTIME_ROOT/bootstrap-oidc-audit"

mkdir -p "$RUNTIME_DIR"
cp terraform/environments/bootstrap-oidc-audit/*.tf "$RUNTIME_DIR/"

cat > "$RUNTIME_DIR/terraform.tfvars" <<TFVARS
cloud_id              = "$YC_CLOUD_ID_VALUE"
folder_id             = "$YC_FOLDER_ID_VALUE"
zone                  = "$YC_ZONE_VALUE"
iam_token             = "$YC_TOKEN_VALUE"
github_owner          = "$YCSEC_GITHUB_OWNER"
github_repo           = "$YCSEC_GITHUB_REPO"
github_branch         = "$YCSEC_GITHUB_BRANCH"
audit_bucket_name     = "$AUDIT_BUCKET_NAME"
audit_bucket_max_size = 104857600
TFVARS

ok "temporary Terraform runtime prepared: $RUNTIME_DIR"
ok "terraform.tfvars written only inside temporary runtime directory"
ok "audit bucket name selected: $AUDIT_BUCKET_NAME"

echo
echo "Terraform formatting"
terraform -chdir="$RUNTIME_DIR" fmt -check -recursive
if test "$?" -eq 0; then
  ok "terraform fmt"
else
  fail "terraform fmt failed"
fi

echo
echo "Terraform init"
terraform -chdir="$RUNTIME_DIR" init -input=false
if test "$?" -eq 0; then
  ok "terraform init"
else
  fail "terraform init failed"
fi

echo
echo "Terraform validate"
terraform -chdir="$RUNTIME_DIR" validate
if test "$?" -eq 0; then
  ok "terraform validate"
else
  fail "terraform validate failed"
fi

echo
echo "Terraform plan"
terraform -chdir="$RUNTIME_DIR" plan -input=false -out="$RUNTIME_ROOT/tfplan"
if test "$?" -eq 0; then
  ok "terraform plan saved in temporary runtime directory"
else
  fail "terraform plan failed"
fi

echo
echo "Sensitive file checks before apply"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && fail "Terraform state files found in repository" || ok "No Terraform state files in repository"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && fail "kubeconfig-like files found in repository" || ok "No kubeconfig files in repository"
find . \( -iname "*token*" -o -iname "*.key" -o -iname "*.pem" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" \) ! -path "./.git/*" | grep -q . && fail "key/token-like files found in repository" || ok "No key/token-like files in repository"

if test "$FAIL_COUNT" -ne 0; then
  echo
  echo "[FAIL] pre-apply checks failed"
  echo "[ACTION] review output before continuing"
  rm -rf "$RUNTIME_ROOT"
  exit 0
fi

echo
echo "Terraform apply"
APPLY_OK=0
terraform -chdir="$RUNTIME_DIR" apply -input=false -auto-approve "$RUNTIME_ROOT/tfplan"
if test "$?" -eq 0; then
  APPLY_OK=1
  ok "terraform apply completed"
else
  fail "terraform apply failed"
fi

echo
echo "Bootstrap outputs"
if test "$APPLY_OK" -eq 1; then
  terraform -chdir="$RUNTIME_DIR" output -json | jq .
  ok "Terraform outputs collected"
else
  warn "outputs skipped because apply did not complete"
fi

echo
echo "Read-only cloud inventory after apply"
yc iam service-account list | grep -E "ycsec-bootstrap|ID|\\+" || true
yc iam workload-identity oidc federation list | grep -E "ycsec-bootstrap|ID|\\+" || true
yc container registry list | grep -E "ycsec-bootstrap|ID|\\+" || true
yc storage bucket list | grep -E "$AUDIT_BUCKET_NAME|NAME|\\+" || true
yc audit-trails trail list | grep -E "ycsec-bootstrap|ID|\\+" || true

echo
echo "Secret scan"
gitleaks detect --source . --no-git -v
if test "$?" -eq 0; then
  ok "gitleaks secret scan"
else
  fail "gitleaks found potential leaks"
fi

echo
echo "Destroy decision"
if test "$DESTROY_AFTER_RUN" = "YES"; then
  ok "destroy after run is enabled"
  terraform -chdir="$RUNTIME_DIR" destroy -input=false -auto-approve
  if test "$?" -eq 0; then
    ok "terraform destroy completed"
  else
    fail "terraform destroy failed"
  fi

  echo
  echo "Post-destroy read-only bootstrap resource check"
  yc iam service-account list | grep -E "ycsec-bootstrap|ID|\\+" || true
  yc iam workload-identity oidc federation list | grep -E "ycsec-bootstrap|ID|\\+" || true
  yc container registry list | grep -E "ycsec-bootstrap|ID|\\+" || true
  yc storage bucket list | grep -E "$AUDIT_BUCKET_NAME|NAME|\\+" || true
  yc audit-trails trail list | grep -E "ycsec-bootstrap|ID|\\+" || true
else
  warn "bootstrap resources retained by explicit configuration"
  echo "[ACTION] run terraform destroy from temporary runtime or documented cleanup path when evidence collection is complete"
fi

echo
echo "Sensitive file checks after run"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && fail "Terraform state files found in repository after run" || ok "No Terraform state files after run"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && fail "kubeconfig-like files found in repository after run" || ok "No kubeconfig files after run"
find . \( -iname "*token*" -o -iname "*.key" -o -iname "*.pem" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" \) ! -path "./.git/*" | grep -q . && fail "key/token-like files found in repository after run" || ok "No key/token-like files after run"

echo
echo "Cleanup"
if test "${YCSEC_BOOTSTRAP_DESTROY_AFTER_RUN:-}" = "YES" || test "${YCSEC_DESTROY_AFTER_RUN:-}" = "YES"; then
  rm -rf "$RUNTIME_ROOT"
  ok "temporary runtime directory removed"
else
  PRIVATE_STATE_DIR_BASE="${YCSEC_PRIVATE_STATE_ROOT:-$HOME/ycsec-private-evidence/phase-12.8b}"
  PRIVATE_STATE_DIR="$PRIVATE_STATE_DIR_BASE/bootstrap-terraform-runtime-${RUN_ID}"
  mkdir -p "$PRIVATE_STATE_DIR_BASE"
  rm -rf "$PRIVATE_STATE_DIR"
  mv "$RUNTIME_ROOT" "$PRIVATE_STATE_DIR"
  chmod -R go-rwx "$PRIVATE_STATE_DIR"
  printf "%s\n" "$PRIVATE_STATE_DIR" > "$PRIVATE_STATE_DIR_BASE/bootstrap-runtime-path.txt"
  ok "temporary runtime preserved outside repository for controlled cleanup: $PRIVATE_STATE_DIR"
fi

echo
echo "Bootstrap run summary"
echo "Warnings: $WARN_COUNT"
echo "Failures: $FAIL_COUNT"

if test "$FAIL_COUNT" -eq 0; then
  ok "Bootstrap/OIDC/Audit cloud-run completed"
else
  fail "Bootstrap/OIDC/Audit cloud-run completed with failures"
fi
