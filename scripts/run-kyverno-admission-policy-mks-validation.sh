#!/usr/bin/env bash
set -Eeuo pipefail

echo "YCSEC Phase 13.5 — Kyverno admission policy enforcement on Managed Kubernetes"
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
    ok "$1 available"
  else
    fail "$1 missing"
  fi
}

sanitize_file() {
  SRC="$1"
  DST="$2"

  if [ ! -s "$SRC" ]; then
    : > "$DST"
    return 0
  fi

  sed -E \
    -e 's#cr[.]yandex/[a-z0-9]+#cr.yandex/<registry-id>#g' \
    -e 's#(id[ =:]+)[a-z0-9]{18,}#\1<resource-id>#g' \
    -e 's#(cluster_id[ =:]+)[a-z0-9]{18,}#\1<cluster-id>#g' \
    -e 's#(node_group_id[ =:]+)[a-z0-9]{18,}#\1<node-group-id>#g' \
    -e 's#(network_id[ =:]+)[a-z0-9]{18,}#\1<network-id>#g' \
    -e 's#(subnet_id[ =:]+)[a-z0-9]{18,}#\1<subnet-id>#g' \
    -e 's#(folder_id[ =:]+)[a-z0-9]{18,}#\1<folder-id>#g' \
    -e 's#(cloud_id[ =:]+)[a-z0-9]{18,}#\1<cloud-id>#g' \
    -e 's#([0-9]{1,3}[.]){3}[0-9]{1,3}#<ip-address>#g' \
    -e 's#Bearer [A-Za-z0-9._-]+#Bearer <redacted>#g' \
    "$SRC" > "$DST"
}

cleanup() {
  set +e

  echo
  echo "Cleanup — terraform destroy Managed Kubernetes resources"

  if [ -n "${RUNTIME_DIR:-}" ] && [ -d "$RUNTIME_DIR" ]; then
    terraform -chdir="$RUNTIME_DIR" destroy -auto-approve \
      > "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt" 2>&1
    DESTROY_RC=$?

    cat "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt"
    sanitize_file "$PRIVATE_DIR/terraform_destroy_RAW_PRIVATE.txt" \
      "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt"

    if [ "$DESTROY_RC" -eq 0 ]; then
      ok "terraform destroy completed"
    else
      fail "terraform destroy returned non-zero"
    fi
  else
    warn "Terraform runtime directory was not created"
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

  rm -rf "${RUNTIME_DIR:-}" 2>/dev/null || true
}
trap cleanup EXIT

if [ "${YCSEC_CONFIRM_KYVERNO_MKS_RUN:-}" != "YES" ]; then
  fail "explicit Kyverno MKS cloud-run approval is missing"
  exit 1
fi
ok "explicit Kyverno MKS cloud-run approval provided"

for CMD in yc terraform kubectl jq curl tar grep sed awk find gitleaks; do
  need_cmd "$CMD"
done

if [ "$FAIL_COUNT" -ne 0 ]; then
  fail "required tools missing"
  exit 1
fi

CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"
ZONE="${YCSEC_MKS_ZONE:-ru-central1-a}"

if [ -n "$CLOUD_ID" ]; then ok "cloud-id configured"; else fail "cloud-id missing"; fi
if [ -n "$FOLDER_ID" ]; then ok "folder-id configured"; else fail "folder-id missing"; fi
ok "zone selected: $ZONE"

IAM_TOKEN="$(yc iam create-token)"
if [ -n "$IAM_TOKEN" ]; then ok "short-lived IAM token created"; else fail "IAM token creation failed"; fi

if [ "$FAIL_COUNT" -ne 0 ]; then
  exit 1
fi

REGISTRY_ID="$(
  yc container registry list --format json \
    | jq -r '.[] | select(.name=="ycsec-bootstrap-registry") | .id' \
    | head -n 1
)"

if [ -n "$REGISTRY_ID" ]; then
  ok "retained Yandex Container Registry detected"
else
  fail "retained Yandex Container Registry not detected"
  exit 1
fi

HARDENED_TAG="$(
  yc container image list --registry-id "$REGISTRY_ID" --format json \
    | jq -r '.[] | select(.name | contains("ycsec-supply-chain-demo:hardened-")) | .name' \
    | sed 's#^cr.yandex/[^/]*/##' \
    | sed 's#^ycsec-supply-chain-demo:##' \
    | head -n 1
)"

if [ -z "$HARDENED_TAG" ]; then
  fail "hardened registry image tag not detected"
  exit 1
fi

HARDENED_IMAGE="cr.yandex/${REGISTRY_ID}/ycsec-supply-chain-demo:${HARDENED_TAG}"
echo "Hardened image: cr.yandex/<registry-id>/ycsec-supply-chain-demo:${HARDENED_TAG}"
ok "hardened registry image detected for admission allow test"

PRIVATE_DIR="$HOME/ycsec-private-evidence/phase-13.5/kyverno-admission-$(date +%Y%m%dT%H%M%S)"
RUNTIME_DIR="$PRIVATE_DIR/terraform-runtime"
KUBE_HOME="$PRIVATE_DIR/kube-home"
KUBECONFIG_PATH="$KUBE_HOME/.kube/config"
ORIGINAL_HOME="$HOME"

mkdir -p "$PRIVATE_DIR" "$RUNTIME_DIR" "$KUBE_HOME/.kube" evidence/after evidence/sanitized evidence/command-outputs

echo
echo "Step A — prepare temporary Terraform runtime outside repository"
tar --exclude='.terraform' --exclude='.terraform.lock.hcl' -cf - terraform/environments/managed-kubernetes-cloud-run \
  | tar -xf - -C "$PRIVATE_DIR"

mv "$PRIVATE_DIR/terraform/environments/managed-kubernetes-cloud-run"/* "$RUNTIME_DIR"/
rm -rf "$PRIVATE_DIR/terraform"

cat > "$RUNTIME_DIR/terraform.tfvars" <<TFVARS
cloud_id     = "$CLOUD_ID"
folder_id    = "$FOLDER_ID"
zone         = "$ZONE"
iam_token    = "$IAM_TOKEN"
cluster_name = "ycsec-kyverno-mks-$(date +%Y%m%d%H%M%S)"
node_count   = 1
TFVARS

ok "temporary Terraform runtime prepared with declared variables only"

echo
echo "Step B — terraform init/validate/plan/apply with visible progress"
export YC_TOKEN="$IAM_TOKEN"
export YC_CLOUD_ID="$CLOUD_ID"
export YC_FOLDER_ID="$FOLDER_ID"

terraform -chdir="$RUNTIME_DIR" init
terraform -chdir="$RUNTIME_DIR" validate

terraform -chdir="$RUNTIME_DIR" plan \
  > "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/terraform_plan_RAW_PRIVATE.txt" \
  "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt"
ok "terraform plan completed"

terraform -chdir="$RUNTIME_DIR" apply -auto-approve \
  > "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/terraform_apply_RAW_PRIVATE.txt" \
  "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt"
ok "terraform apply completed"

CLUSTER_ID="$(terraform -chdir="$RUNTIME_DIR" output -raw cluster_id 2>/dev/null || true)"
if [ -n "$CLUSTER_ID" ]; then
  ok "cluster_id obtained from Terraform output"
else
  fail "cluster_id missing from Terraform output"
  exit 1
fi

echo
echo "Step C — obtain isolated kubeconfig"
if [ -d "$ORIGINAL_HOME/.config/yandex-cloud" ]; then
  mkdir -p "$KUBE_HOME/.config"
  cp -a "$ORIGINAL_HOME/.config/yandex-cloud" "$KUBE_HOME/.config/"
  ok "Yandex CLI config copied to private kube home"
else
  warn "Yandex CLI config directory not found; relying on YC_* environment variables"
fi

HOME="$KUBE_HOME" \
YC_TOKEN="$IAM_TOKEN" \
YC_CLOUD_ID="$CLOUD_ID" \
YC_FOLDER_ID="$FOLDER_ID" \
yc managed-kubernetes cluster get-credentials --id "$CLUSTER_ID" --external --force \
  > "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt" 2>&1

cat "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/get_credentials_RAW_PRIVATE.txt" \
  "evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_get_credentials_sanitized.txt"

if [ -s "$KUBECONFIG_PATH" ]; then
  ok "isolated kubeconfig created: private kube home"
else
  fail "isolated kubeconfig was not created"
  exit 1
fi

export KUBECONFIG="$KUBECONFIG_PATH"

kubectl --kubeconfig "$KUBECONFIG_PATH" cluster-info \
  > "$PRIVATE_DIR/kubectl_cluster_info_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kubectl_cluster_info_RAW_PRIVATE.txt"
ok "kubectl cluster-info succeeded with isolated kubeconfig"

echo
echo "Step D — wait for node readiness"
NODE_READY=0
for ATTEMPT in $(seq 1 40); do
  echo "[INFO] node readiness attempt $ATTEMPT/40"

  if kubectl --kubeconfig "$KUBECONFIG_PATH" get nodes -o wide \
    > "$PRIVATE_DIR/kubectl_nodes_attempt_${ATTEMPT}_RAW_PRIVATE.txt" 2>&1; then
    cat "$PRIVATE_DIR/kubectl_nodes_attempt_${ATTEMPT}_RAW_PRIVATE.txt"

    if grep -q " Ready " "$PRIVATE_DIR/kubectl_nodes_attempt_${ATTEMPT}_RAW_PRIVATE.txt"; then
      sanitize_file "$PRIVATE_DIR/kubectl_nodes_attempt_${ATTEMPT}_RAW_PRIVATE.txt" \
        "evidence/after/kyverno_mks_nodes_ready.txt"
      NODE_READY=1
      ok "node became Ready"
      break
    fi
  else
    cat "$PRIVATE_DIR/kubectl_nodes_attempt_${ATTEMPT}_RAW_PRIVATE.txt"
  fi

  sleep 15
done

if [ "$NODE_READY" -ne 1 ]; then
  fail "node did not become Ready"
  exit 1
fi

echo
echo "Step E — install Kyverno admission controller"
KYVERNO_INSTALL_URL="${KYVERNO_INSTALL_URL:-https://github.com/kyverno/kyverno/releases/download/v1.13.4/install.yaml}"

kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f "$KYVERNO_INSTALL_URL" \
  > "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_install_apply_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_install_apply.txt"
ok "Kyverno install manifest applied"

kubectl --kubeconfig "$KUBECONFIG_PATH" -n kyverno rollout status deployment/kyverno-admission-controller --timeout=300s \
  > "$PRIVATE_DIR/kyverno_controller_rollout_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_controller_rollout_RAW_PRIVATE.txt"

kubectl --kubeconfig "$KUBECONFIG_PATH" -n kyverno get pods -o wide \
  > "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_controller_pods_READY_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_controller_pods_ready.txt"
ok "Kyverno admission controller is ready"

echo
echo "Step F — apply namespace and Kyverno policy"
kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f kubernetes/admission-validation/namespace.yaml \
  > "$PRIVATE_DIR/namespace_apply_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/namespace_apply_RAW_PRIVATE.txt"

kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f kubernetes/admission-validation/kyverno-supply-chain-policy.yaml \
  > "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_policy_apply_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_policy_apply.txt"
ok "Kyverno supply-chain admission policy applied"

sleep 15

kubectl --kubeconfig "$KUBECONFIG_PATH" get clusterpolicy ycsec-supply-chain-admission-controls -o yaml \
  > "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/kyverno_policy_status_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_policy_status.txt"
ok "Kyverno policy status collected"

echo
echo "Step G — verify insecure workload is denied"
set +e
kubectl --kubeconfig "$KUBECONFIG_PATH" apply --dry-run=server \
  -f kubernetes/admission-validation/insecure-workload-denied.yaml \
  > "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" 2>&1
INSECURE_RC=$?
set -e

cat "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_insecure_workload_denied.txt"

if [ "$INSECURE_RC" -ne 0 ] && grep -Ei 'ycsec-supply-chain-admission-controls|require-yandex-container-registry|require-non-root-container|deny-privilege-escalation|require-read-only-root-filesystem|require-capabilities-drop-all|require-runtime-default-seccomp|admission webhook.*kyverno|kyverno|Container images must be pulled from Yandex Container Registry|Containers must run as non-root|Privilege escalation must be disabled' "$PRIVATE_DIR/insecure_workload_denied_RAW_PRIVATE.txt" >/dev/null 2>&1; then
  ok "insecure workload was denied by Kyverno admission policy"
else
  fail "insecure workload was not clearly denied by Kyverno admission policy"
  exit 1
fi

echo
echo "Step H — verify hardened workload is allowed"
HARDENED_RENDERED="$PRIVATE_DIR/hardened-workload-rendered.yaml"
sed "s#IMAGE_PLACEHOLDER#$HARDENED_IMAGE#g" \
  kubernetes/admission-validation/hardened-workload-allowed.yaml \
  > "$HARDENED_RENDERED"

kubectl --kubeconfig "$KUBECONFIG_PATH" apply --dry-run=server -f "$HARDENED_RENDERED" \
  > "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" 2>&1
cat "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt"
sanitize_file "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" \
  "evidence/after/kyverno_hardened_workload_allowed.txt"

if grep -Ei 'configured|created|unchanged|dry run|ycsec-hardened-workload-allowed' "$PRIVATE_DIR/hardened_workload_allowed_RAW_PRIVATE.txt" >/dev/null 2>&1; then
  ok "hardened workload passed server-side admission validation"
else
  fail "hardened workload was not clearly allowed"
  exit 1
fi

echo
echo "Step I — create consolidated sanitized evidence"
{
  echo "Kyverno admission policy enforcement validation"
  echo "Date: $(date -Is)"
  echo
  echo "[OK] short-lived Managed Kubernetes cluster created"
  echo "[OK] node became Ready"
  echo "[OK] Kyverno admission controller installed"
  echo "[OK] supply-chain admission policy applied"
  echo "[OK] insecure workload denied by Kyverno admission policy"
  echo "[OK] hardened workload allowed by server-side admission validation"
  echo "[OK] Terraform destroy is executed by cleanup trap"
} > evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt

ok "sanitized admission evidence written"

echo
echo "Kyverno admission run summary"
echo "Warnings: $WARN_COUNT"
echo "Failures: $FAIL_COUNT"
echo "Private evidence: $PRIVATE_DIR"

if [ "$FAIL_COUNT" -eq 0 ]; then
  ok "Kyverno admission validation completed successfully"
else
  fail "Kyverno admission validation completed with failures"
  exit 1
fi
