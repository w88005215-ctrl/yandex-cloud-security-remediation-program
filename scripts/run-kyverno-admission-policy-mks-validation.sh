#!/usr/bin/env bash
set -Eeuo pipefail

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
    ok "$1 available"
  else
    fail "$1 missing"
  fi
}

sanitize_stream() {
  sed -E \
    -e 's#cr[.]yandex/[a-z0-9]+#cr.yandex/<registry-id>#g' \
    -e 's#https://[0-9]{1,3}([.][0-9]{1,3}){3}#https://<external-endpoint>#g' \
    -e 's#[0-9]{1,3}([.][0-9]{1,3}){3}#<ip-address>#g' \
    -e 's#(folder_id|cloud_id|network_id|subnet_id|cluster_id|node_group_id)[ =:"]+[a-z0-9]{12,}#\1=<resource-id>#g' \
    -e 's#(id|ID)[ =:"]+[a-z0-9]{12,}#\1=<resource-id>#g' \
    -e 's#serviceAccount:[a-z0-9]{12,}#serviceAccount:<service-account-id>#g' \
    -e 's#-----BEGIN CERTIFICATE-----.*-----END CERTIFICATE-----#<certificate-redacted>#g'
}

sanitize_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"

  if [ -f "$src" ]; then
    sanitize_stream < "$src" > "$dst"
  else
    : > "$dst"
  fi
}

run_and_capture() {
  local private_file="$1"
  shift

  set +e
  "$@" 2>&1 | tee "$private_file"
  local rc=${PIPESTATUS[0]}
  set -e

  return "$rc"
}

RUN_TS="$(date -u +%Y%m%d%H%M%S)"
PRIVATE_DIR="${PRIVATE_DIR:-$HOME/ycsec-private-evidence/phase-13.5/kyverno-admission-${RUN_TS}}"
RUNTIME_DIR="${RUNTIME_DIR:-$PRIVATE_DIR/terraform-runtime}"
KUBE_HOME="${KUBE_HOME:-$PRIVATE_DIR/kube-home}"
KUBECONFIG_PATH="${KUBECONFIG_PATH:-$KUBE_HOME/.kube/config}"
ORIGINAL_HOME="$HOME"

mkdir -p "$PRIVATE_DIR" evidence/after evidence/sanitized evidence/command-outputs

cleanup() {
  set +e

  echo
  echo "Cleanup — terraform destroy Managed Kubernetes resources"

  mkdir -p "$PRIVATE_DIR" evidence/command-outputs

  if [ -n "${RUNTIME_DIR:-}" ] && [ -d "$RUNTIME_DIR" ] && [ -f "$RUNTIME_DIR/main.tf" ]; then
    terraform -chdir="$RUNTIME_DIR" destroy -auto-approve -compact-warnings \
      2>&1 | tee "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt"

    sanitize_file "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt" \
      "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt"
  else
    echo "[WARN] Terraform runtime directory was not created" \
      | tee "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt"

    sanitize_file "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt" \
      "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt"
  fi

  yc managed-kubernetes cluster list \
    > "$PRIVATE_DIR/post_destroy_mks_cluster_list_RAW_PRIVATE.txt" 2>&1 || true
  sanitize_file "$PRIVATE_DIR/post_destroy_mks_cluster_list_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt"

  yc compute instance list \
    > "$PRIVATE_DIR/post_destroy_compute_instance_list_RAW_PRIVATE.txt" 2>&1 || true
  sanitize_file "$PRIVATE_DIR/post_destroy_compute_instance_list_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt"

  yc load-balancer network-load-balancer list \
    > "$PRIVATE_DIR/post_destroy_nlb_list_RAW_PRIVATE.txt" 2>&1 || true
  sanitize_file "$PRIVATE_DIR/post_destroy_nlb_list_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt"

  rm -rf "${RUNTIME_DIR:-}" "${KUBE_HOME:-}" 2>/dev/null || true

  echo "[OK] cleanup evidence collected"
  return 0
}

trap cleanup EXIT

echo "YCSEC Phase 13.5 — Kyverno admission policy enforcement on Managed Kubernetes"
echo "Date: $(date -Is)"
echo "Qube: $(hostname)"
echo

if [ "${YCSEC_CONFIRM_KYVERNO_MKS_RUN:-}" = "YES" ]; then
  ok "explicit Kyverno MKS cloud-run approval provided"
else
  fail "explicit approval missing: set YCSEC_CONFIRM_KYVERNO_MKS_RUN=YES"
  exit 1
fi

for cmd in yc terraform kubectl jq curl tar grep sed awk find gitleaks; do
  need_cmd "$cmd"
done

if [ "$FAIL_COUNT" -ne 0 ]; then
  fail "required tool checks failed"
  exit 1
fi

CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"
ZONE="${YCSEC_MKS_ZONE:-ru-central1-a}"

if [ -n "$CLOUD_ID" ]; then
  ok "cloud-id configured"
else
  fail "cloud-id is not configured"
fi

if [ -n "$FOLDER_ID" ]; then
  ok "folder-id configured"
else
  fail "folder-id is not configured"
fi

if [ -n "$ZONE" ]; then
  ok "zone selected: $ZONE"
else
  fail "zone is empty"
fi

IAM_TOKEN="$(yc iam create-token 2>/dev/null || true)"
if [ -n "$IAM_TOKEN" ]; then
  ok "short-lived IAM token created"
else
  fail "failed to create short-lived IAM token"
fi

REGISTRY_ID="$(
  yc container registry list --format json \
    | jq -r '.[] | select(.name=="ycsec-bootstrap-registry") | .id' \
    | head -n 1
)"

if [ -n "$REGISTRY_ID" ] && [ "$REGISTRY_ID" != "null" ]; then
  ok "retained Yandex Container Registry detected"
else
  fail "retained Yandex Container Registry not detected"
fi

if [ "$FAIL_COUNT" -ne 0 ]; then
  fail "cloud context checks failed before paid action"
  exit 1
fi

HARDENED_IMAGE="${YCSEC_HARDENED_IMAGE:-}"

if [ -n "$HARDENED_IMAGE" ]; then
  if echo "$HARDENED_IMAGE" | grep -Eq '^cr[.]yandex/[a-z0-9]+/ycsec-supply-chain-demo:hardened-[0-9a-f]{7,40}$'; then
    ok "hardened image accepted from YCSEC_HARDENED_IMAGE"
  else
    fail "YCSEC_HARDENED_IMAGE has unexpected format"
    exit 1
  fi
else
  HARDENED_TAG="$(
    grep -RhoE 'hardened-[0-9a-f]{7,40}' docs evidence .github supply-chain 2>/dev/null \
      | sort -u \
      | tail -n 1
  )"

  if [ -z "$HARDENED_TAG" ]; then
    fail "hardened image tag not detected from committed evidence"
    exit 1
  fi

  HARDENED_IMAGE="cr.yandex/${REGISTRY_ID}/ycsec-supply-chain-demo:${HARDENED_TAG}"
  ok "hardened image detected from committed evidence"
fi

HARDENED_TAG="${HARDENED_IMAGE##*:}"
echo "Hardened image: cr.yandex/<registry-id>/ycsec-supply-chain-demo:${HARDENED_TAG}"
echo "$HARDENED_IMAGE" > "$PRIVATE_DIR/hardened_image_private.txt"

echo
echo "Step A — prepare temporary Terraform runtime outside repository"
mkdir -p "$RUNTIME_DIR" "$KUBE_HOME/.kube" "$KUBE_HOME/.config"

cp -a terraform/environments/managed-kubernetes-cloud-run/. "$RUNTIME_DIR"/

cat > "$RUNTIME_DIR/terraform.tfvars" <<TFVARS
cloud_id         = "$CLOUD_ID"
folder_id        = "$FOLDER_ID"
zone             = "$ZONE"
iam_token        = "$IAM_TOKEN"
cluster_name     = "ycsec-kyverno-mks-${RUN_TS}"
network_cidr     = "10.130.0.0/24"
node_count       = 1
node_platform_id = "standard-v3"
node_cores       = 2
node_memory      = 4
node_disk_type   = "network-hdd"
node_disk_size   = 32
node_preemptible = true
TFVARS

ok "temporary Terraform runtime prepared"

echo
echo "Step B — terraform init/validate/plan/apply with visible progress"
export YC_TOKEN="$IAM_TOKEN"
export YC_CLOUD_ID="$CLOUD_ID"
export YC_FOLDER_ID="$FOLDER_ID"

terraform -chdir="$RUNTIME_DIR" init
ok "terraform init passed"

terraform -chdir="$RUNTIME_DIR" validate -compact-warnings
ok "terraform validate passed"

if run_and_capture "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt" \
  terraform -chdir="$RUNTIME_DIR" plan -compact-warnings -out=tfplan; then
  sanitize_file "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt"
  ok "terraform plan completed"
else
  sanitize_file "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt"
  fail "terraform plan failed"
  exit 1
fi

if run_and_capture "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt" \
  terraform -chdir="$RUNTIME_DIR" apply -auto-approve -compact-warnings tfplan; then
  sanitize_file "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt"
  ok "terraform apply completed"
else
  sanitize_file "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt" \
    "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt"
  fail "terraform apply failed"
  exit 1
fi

CLUSTER_ID="$(terraform -chdir="$RUNTIME_DIR" output -raw cluster_id 2>/dev/null || true)"
if [ -n "$CLUSTER_ID" ]; then
  ok "cluster_id obtained from Terraform output"
else
  fail "cluster_id was not obtained from Terraform output"
  exit 1
fi

echo
echo "Step C — obtain isolated kubeconfig"
if [ -d "$ORIGINAL_HOME/.config/yandex-cloud" ]; then
  cp -a "$ORIGINAL_HOME/.config/yandex-cloud" "$KUBE_HOME/.config/"
fi

(
  export HOME="$KUBE_HOME"
  export KUBECONFIG="$KUBECONFIG_PATH"
  export YC_TOKEN="$IAM_TOKEN"
  yc managed-kubernetes cluster get-credentials --id "$CLUSTER_ID" --external --force
) > "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt" 2>&1

cat "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt" \
  "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_get_credentials_sanitized.txt"

if [ -s "$KUBECONFIG_PATH" ]; then
  ok "isolated kubeconfig created"
else
  fail "isolated kubeconfig was not created"
  exit 1
fi

kubectl --kubeconfig "$KUBECONFIG_PATH" cluster-info \
  > "$PRIVATE_DIR/kubectl_cluster_info_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kubectl_cluster_info_RAW_PRIVATE.txt"

echo
echo "Step D — wait for node readiness"
NODE_READY=0

for attempt in $(seq 1 40); do
  echo "[INFO] node readiness attempt $attempt/40"

  if kubectl --kubeconfig "$KUBECONFIG_PATH" get nodes -o wide \
    > "$PRIVATE_DIR/kubectl_nodes_attempt_${attempt}_RAW_PRIVATE.txt" 2>&1; then
    cat "$PRIVATE_DIR/kubectl_nodes_attempt_${attempt}_RAW_PRIVATE.txt"

    if grep -q " Ready " "$PRIVATE_DIR/kubectl_nodes_attempt_${attempt}_RAW_PRIVATE.txt"; then
      sanitize_file "$PRIVATE_DIR/kubectl_nodes_attempt_${attempt}_RAW_PRIVATE.txt" \
        "evidence/after/kyverno_mks_nodes_ready.txt"
      NODE_READY=1
      ok "MKS node is Ready"
      break
    fi
  else
    cat "$PRIVATE_DIR/kubectl_nodes_attempt_${attempt}_RAW_PRIVATE.txt"
  fi

  sleep 15
done

if [ "$NODE_READY" -ne 1 ]; then
  fail "MKS node did not become Ready"
  exit 1
fi

echo
echo "Step E — install Kyverno admission controller"
KYVERNO_INSTALL_URL="${YCSEC_KYVERNO_INSTALL_URL:-https://github.com/kyverno/kyverno/releases/download/v1.13.4/install.yaml}"

if run_and_capture "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt" \
  kubectl --kubeconfig "$KUBECONFIG_PATH" create -f "$KYVERNO_INSTALL_URL"; then
  sanitize_file "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_install_apply.txt"
  ok "Kyverno install manifest applied"
else
  sanitize_file "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_install_apply.txt"
  fail "Kyverno install failed"
  exit 1
fi

kubectl --kubeconfig "$KUBECONFIG_PATH" wait \
  --for condition=established \
  --timeout=180s \
  crd/clusterpolicies.kyverno.io \
  > "$PRIVATE_DIR/kyverno_crd_wait_RAW_PRIVATE.txt" 2>&1 || true
cat "$PRIVATE_DIR/kyverno_crd_wait_RAW_PRIVATE.txt"

kubectl --kubeconfig "$KUBECONFIG_PATH" -n kyverno rollout status \
  deployment/kyverno-admission-controller \
  --timeout=300s \
  > "$PRIVATE_DIR/kyverno_controller_rollout_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_controller_rollout_RAW_PRIVATE.txt"

kubectl --kubeconfig "$KUBECONFIG_PATH" -n kyverno get pods -o wide \
  > "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_controller_pods_ready.txt"

ok "Kyverno admission controller is ready"

echo
echo "Step F — apply validation namespace and Kyverno policy"
kubectl --kubeconfig "$KUBECONFIG_PATH" apply \
  -f kubernetes/admission-validation/namespace.yaml \
  > "$PRIVATE_DIR/namespace_apply_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/namespace_apply_RAW_PRIVATE.txt"

if run_and_capture "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt" \
  kubectl --kubeconfig "$KUBECONFIG_PATH" apply \
    -f kubernetes/admission-validation/kyverno-supply-chain-policy.yaml; then
  sanitize_file "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_policy_apply.txt"
  ok "Kyverno admission policy applied"
else
  sanitize_file "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_policy_apply.txt"
  fail "Kyverno admission policy apply failed"
  exit 1
fi

sleep 20

kubectl --kubeconfig "$KUBECONFIG_PATH" get clusterpolicy \
  ycsec-supply-chain-admission-controls \
  -o yaml \
  > "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_policy_status.txt"

ok "Kyverno policy status captured"

echo
echo "Step G — verify insecure workload is denied by Kyverno"
set +e
kubectl --kubeconfig "$KUBECONFIG_PATH" apply --dry-run=server \
  -f kubernetes/admission-validation/insecure-workload-denied.yaml \
  > "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" 2>&1
INSECURE_RC=$?
set -e

cat "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_insecure_workload_denied.txt"

if [ "$INSECURE_RC" -ne 0 ] && grep -Ei \
  'ycsec-supply-chain-admission-controls|require-yandex-container-registry|require-non-root-container|deny-privilege-escalation|require-read-only-root-filesystem|require-capabilities-drop-all|require-runtime-default-seccomp|admission webhook.*kyverno|kyverno|Container images must be pulled from Yandex Container Registry|Containers must run as non-root|Privilege escalation must be disabled' \
  "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" >/dev/null 2>&1; then
  ok "insecure workload was denied by Kyverno admission policy"
else
  fail "insecure workload denial was not clearly attributed to Kyverno"
  exit 1
fi

echo
echo "Step H — verify hardened workload is allowed"
HARDENED_RENDERED="$PRIVATE_DIR/hardened-workload-rendered.yaml"

sed "s#IMAGE_PLACEHOLDER#$HARDENED_IMAGE#g" \
  kubernetes/admission-validation/hardened-workload-allowed.yaml \
  > "$HARDENED_RENDERED"

if run_and_capture "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" \
  kubectl --kubeconfig "$KUBECONFIG_PATH" apply --dry-run=server -f "$HARDENED_RENDERED"; then
  sanitize_file "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_hardened_workload_allowed.txt"
  ok "hardened workload passed server-side admission validation"
else
  sanitize_file "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" \
    "evidence/after/kyverno_hardened_workload_allowed.txt"
  fail "hardened workload was not allowed by server-side admission validation"
  exit 1
fi

echo
echo "Step I — write sanitized consolidated admission evidence"
{
  echo "YCSEC Kyverno admission policy enforcement evidence"
  echo "Date: $(date -Is)"
  echo
  echo "[OK] short-lived Managed Kubernetes cluster created"
  echo "[OK] MKS node reached Ready"
  echo "[OK] Kyverno admission controller installed"
  echo "[OK] Kyverno admission policy applied"
  echo "[OK] insecure workload denied by Kyverno"
  echo "[OK] hardened registry workload allowed by server-side admission validation"
  echo "[OK] Terraform destroy is executed by cleanup trap"
  echo
  echo "Hardened image: cr.yandex/<registry-id>/ycsec-supply-chain-demo:${HARDENED_TAG}"
} > evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt

echo
echo "Cloud-run summary"
echo "Warnings: $WARN_COUNT"
echo "Failures: $FAIL_COUNT"
echo "Private evidence: $PRIVATE_DIR"

if [ "$FAIL_COUNT" -eq 0 ]; then
  ok "Kyverno admission validation completed successfully"
else
  fail "Kyverno admission validation completed with failures"
  exit 1
fi

trap - EXIT
cleanup
