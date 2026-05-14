#!/usr/bin/env bash

set -u
set -o pipefail

FAIL_COUNT=0
WARN_COUNT=0

ok() { echo "[OK] $1"; }
warn() { echo "[WARN] $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

sanitize_stream() {
  sed -E \
    -e 's/[a-z][a-z0-9]{20,}/<redacted-id>/g' \
    -e 's/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/<redacted-uuid>/g' \
    -e 's/([0-9]{1,3}\.){3}[0-9]{1,3}/<redacted-ip>/g'
}

echo "YCSEC Phase 13.0 — Managed Kubernetes baseline/remediation controlled cloud-run"
echo "Date: $(date -Is)"
echo "Qube: $(hostname)"
echo

if [ "${YCSEC_CONFIRM_MKS_CLOUD_RUN:-}" = "YES" ]; then
  ok "explicit Managed Kubernetes cloud-run approval provided"
else
  fail "set YCSEC_CONFIRM_MKS_CLOUD_RUN=YES to allow paid Managed Kubernetes cloud actions"
fi

DESTROY_AFTER_RUN="${YCSEC_DESTROY_MKS_AFTER_RUN:-YES}"
if [ "$DESTROY_AFTER_RUN" = "YES" ]; then
  ok "Managed Kubernetes resources will be destroyed after evidence collection"
else
  warn "Managed Kubernetes resources will be retained by explicit override"
fi

for tool in yc terraform kubectl jq gitleaks tar grep find sed awk; do
  command -v "$tool" >/dev/null 2>&1 && ok "$tool available" || fail "$tool missing"
done

BASE_DIR="$(pwd)"
TF_SOURCE_DIR="$BASE_DIR/terraform/environments/managed-kubernetes-cloud-run"

CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"
ZONE="$(yc config get compute-default-zone 2>/dev/null || true)"
ZONE="${ZONE:-ru-central1-a}"
IAM_TOKEN="$(yc iam create-token 2>/dev/null || true)"

[ -n "$CLOUD_ID" ] && ok "cloud-id configured" || fail "cloud-id missing"
[ -n "$FOLDER_ID" ] && ok "folder-id configured" || fail "folder-id missing"
[ -n "$IAM_TOKEN" ] && ok "short-lived IAM token created" || fail "failed to create IAM token"

RUN_ID="$(date -u +%Y%m%dT%H%M%S)"
RUNTIME_ROOT="$(mktemp -d "/tmp/ycsec-mks-${RUN_ID}.XXXXXX")"
RUNTIME_DIR="$RUNTIME_ROOT/managed-kubernetes-cloud-run"
PRIVATE_EVIDENCE_DIR="$HOME/ycsec-private-evidence/phase-13.0/managed-kubernetes-${RUN_ID}"
KUBECONFIG_PATH="$PRIVATE_EVIDENCE_DIR/kubeconfig"

mkdir -p "$RUNTIME_DIR" "$PRIVATE_EVIDENCE_DIR" evidence/before evidence/after evidence/sanitized evidence/command-outputs

if [ "$FAIL_COUNT" -eq 0 ]; then
  cp "$TF_SOURCE_DIR"/*.tf "$RUNTIME_DIR"/
  cat > "$RUNTIME_DIR/terraform.tfvars" <<TFVARS
cloud_id  = "$CLOUD_ID"
folder_id = "$FOLDER_ID"
zone      = "$ZONE"
iam_token = "$IAM_TOKEN"
TFVARS
  ok "temporary Terraform runtime prepared outside repository"
fi

if [ "$FAIL_COUNT" -eq 0 ]; then
  terraform -chdir="$RUNTIME_DIR" fmt -check -recursive || fail "terraform fmt failed"
  terraform -chdir="$RUNTIME_DIR" init -input=false || fail "terraform init failed"
  terraform -chdir="$RUNTIME_DIR" validate || fail "terraform validate failed"
fi

if [ "$FAIL_COUNT" -eq 0 ]; then
  terraform -chdir="$RUNTIME_DIR" plan -input=false -out="$RUNTIME_ROOT/tfplan" \
    2>&1 | tee "$PRIVATE_EVIDENCE_DIR/terraform_plan_RAW_PRIVATE.txt" | sanitize_stream \
    > evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_plan_sanitized.txt
  [ "${PIPESTATUS[0]}" -eq 0 ] && ok "terraform plan saved" || fail "terraform plan failed"
fi

if [ "$FAIL_COUNT" -eq 0 ]; then
  terraform -chdir="$RUNTIME_DIR" apply -input=false -auto-approve "$RUNTIME_ROOT/tfplan" \
    2>&1 | tee "$PRIVATE_EVIDENCE_DIR/terraform_apply_RAW_PRIVATE.txt" | sanitize_stream \
    > evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_apply_sanitized.txt
  [ "${PIPESTATUS[0]}" -eq 0 ] && ok "terraform apply completed" || fail "terraform apply failed"
fi

if [ "$FAIL_COUNT" -eq 0 ]; then
  CLUSTER_ID="$(terraform -chdir="$RUNTIME_DIR" output -raw cluster_id 2>/dev/null || true)"
  export KUBECONFIG="$KUBECONFIG_PATH"

  yc managed-kubernetes cluster get-credentials --id "$CLUSTER_ID" --external --force \
    2>&1 | tee "$PRIVATE_EVIDENCE_DIR/get_credentials_RAW_PRIVATE.txt" | sanitize_stream \
    > evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_get_credentials_sanitized.txt

  kubectl get nodes -o wide 2>&1 | tee "$PRIVATE_EVIDENCE_DIR/kubectl_nodes_RAW_PRIVATE.txt" | sanitize_stream > evidence/before/yc_mks_nodes_ready.txt
  kubectl apply -f "$BASE_DIR/kubernetes/cloud-run/insecure-baseline" 2>&1 | sanitize_stream > evidence/before/kubectl_apply_insecure_baseline.txt
  kubectl get all -n ycsec-insecure-baseline -o wide 2>&1 | sanitize_stream > evidence/before/kubectl_get_all_insecure.txt

  if command -v trivy >/dev/null 2>&1; then
    trivy k8s --report summary cluster 2>&1 | sanitize_stream > evidence/before/trivy_k8s_before.txt || warn "trivy before scan returned non-zero"
  fi

  if command -v kube-score >/dev/null 2>&1; then
    kube-score score "$BASE_DIR"/kubernetes/cloud-run/insecure-baseline/*.yaml > evidence/before/kube_score_before.txt 2>&1 || warn "kube-score before scan returned non-zero"
  fi

  kubectl delete namespace ycsec-insecure-baseline --ignore-not-found=true 2>&1 | sanitize_stream > evidence/after/kubectl_delete_insecure_baseline.txt
  kubectl apply -f "$BASE_DIR/kubernetes/cloud-run/hardened" 2>&1 | sanitize_stream > evidence/after/kubectl_apply_hardened.txt
  kubectl get all -n ycsec-hardened -o wide 2>&1 | sanitize_stream > evidence/after/kubectl_get_all_hardened.txt
  kubectl auth can-i --list --as system:serviceaccount:ycsec-hardened:hardened-web-sa -n ycsec-hardened 2>&1 | sanitize_stream > evidence/after/kubectl_auth_can_i.txt
  kubectl get networkpolicy -n ycsec-hardened -o yaml 2>&1 | sanitize_stream > evidence/after/network_policy_validation.txt
  kubectl get ns ycsec-hardened --show-labels 2>&1 | sanitize_stream > evidence/after/pod_security_labels.txt

  if command -v trivy >/dev/null 2>&1; then
    trivy k8s --report summary cluster 2>&1 | sanitize_stream > evidence/after/trivy_k8s_after.txt || warn "trivy after scan returned non-zero"
  fi

  if command -v kube-score >/dev/null 2>&1; then
    kube-score score "$BASE_DIR"/kubernetes/cloud-run/hardened/*.yaml > evidence/after/kube_score_after.txt 2>&1 || warn "kube-score after scan returned non-zero"
  fi
fi

if [ "$DESTROY_AFTER_RUN" = "YES" ] && [ -d "$RUNTIME_DIR" ]; then
  terraform -chdir="$RUNTIME_DIR" destroy -input=false -auto-approve \
    2>&1 | tee "$PRIVATE_EVIDENCE_DIR/terraform_destroy_RAW_PRIVATE.txt" | sanitize_stream \
    > evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_destroy_sanitized.txt
  [ "${PIPESTATUS[0]}" -eq 0 ] && ok "terraform destroy completed" || fail "terraform destroy failed"

  yc managed-kubernetes cluster list | sanitize_stream > evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_mks_cluster_list.txt
  yc compute instance list | sanitize_stream > evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_compute_instance_list.txt
  yc load-balancer network-load-balancer list | sanitize_stream > evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_nlb_list.txt
else
  warn "Managed Kubernetes resources retained by explicit override"
fi

find . \( -name "*.tfstate" -o -name "*.tfstate.*" \) -print -quit | grep -q . && fail "Terraform state found in repository" || ok "no Terraform state files in repository"
find . -iname "*kubeconfig*" -print -quit | grep -q . && fail "kubeconfig-like file found in repository" || ok "no kubeconfig files in repository"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" \) -print -quit | grep -q . && fail "key/token-like file found in repository" || ok "no key/token-like files in repository"

gitleaks detect --source . --no-banner
[ "$?" -eq 0 ] && ok "gitleaks final scan passed" || fail "gitleaks final scan failed"

echo
echo "Cloud-run summary"
echo "Warnings: $WARN_COUNT"
echo "Failures: $FAIL_COUNT"
echo "Private evidence: $PRIVATE_EVIDENCE_DIR"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
