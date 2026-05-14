#!/usr/bin/env bash

set -u

FAIL_COUNT=0

ok() { echo "[OK] $1"; }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

echo "YCSEC Managed Kubernetes cloud-run package validator"
echo "Date: $(date -Is)"
echo

for path in \
  terraform/environments/managed-kubernetes-cloud-run/main.tf \
  terraform/environments/managed-kubernetes-cloud-run/variables.tf \
  terraform/environments/managed-kubernetes-cloud-run/outputs.tf \
  scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh \
  kubernetes/cloud-run/insecure-baseline/namespace.yaml \
  kubernetes/cloud-run/insecure-baseline/rbac-overpermissive.yaml \
  kubernetes/cloud-run/insecure-baseline/workload-insecure.yaml \
  kubernetes/cloud-run/hardened/namespace.yaml \
  kubernetes/cloud-run/hardened/rbac-least-privilege.yaml \
  kubernetes/cloud-run/hardened/workload-hardened.yaml \
  kubernetes/cloud-run/hardened/network-policies.yaml \
  policies/kyverno/cloud-run/baseline-remediation-controls.yaml; do
  [ -f "$path" ] && ok "$path exists" || fail "$path missing"
done

bash -n scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh && ok "cloud-run script syntax valid" || fail "cloud-run script syntax invalid"

grep -q "YCSEC_CONFIRM_MKS_CLOUD_RUN" scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh && ok "explicit cloud approval gate present" || fail "explicit cloud approval gate missing"
grep -q "terraform destroy" scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh && ok "terraform destroy path present" || fail "terraform destroy path missing"
grep -q "ycsec-private-evidence" scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh && ok "private evidence path present" || fail "private evidence path missing"

grep -q "privileged: true" kubernetes/cloud-run/insecure-baseline/workload-insecure.yaml && ok "privileged baseline present" || fail "privileged baseline missing"
grep -q "runAsUser: 0" kubernetes/cloud-run/insecure-baseline/workload-insecure.yaml && ok "root execution baseline present" || fail "root execution baseline missing"
grep -q "allowPrivilegeEscalation: true" kubernetes/cloud-run/insecure-baseline/workload-insecure.yaml && ok "privilege escalation baseline present" || fail "privilege escalation baseline missing"
grep -q "image: nginx:latest" kubernetes/cloud-run/insecure-baseline/workload-insecure.yaml && ok "mutable image tag baseline present" || fail "mutable image tag baseline missing"

grep -q "runAsNonRoot: true" kubernetes/cloud-run/hardened/workload-hardened.yaml && ok "non-root remediation present" || fail "non-root remediation missing"
grep -q "allowPrivilegeEscalation: false" kubernetes/cloud-run/hardened/workload-hardened.yaml && ok "privilege escalation remediation present" || fail "privilege escalation remediation missing"
grep -q "readOnlyRootFilesystem: true" kubernetes/cloud-run/hardened/workload-hardened.yaml && ok "read-only root filesystem remediation present" || fail "read-only root filesystem remediation missing"
grep -q "drop:" kubernetes/cloud-run/hardened/workload-hardened.yaml && ok "capability drop remediation present" || fail "capability drop remediation missing"
grep -q "NetworkPolicy" kubernetes/cloud-run/hardened/network-policies.yaml && ok "NetworkPolicy remediation present" || fail "NetworkPolicy remediation missing"
grep -q "validationFailureAction: Enforce" policies/kyverno/cloud-run/baseline-remediation-controls.yaml && ok "Kyverno enforce policy present" || fail "Kyverno enforce policy missing"

if awk '/resource "yandex_kubernetes_node_group" "workers"/,/^}/' terraform/environments/managed-kubernetes-cloud-run/main.tf | grep -q "folder_id"; then
  fail "unsupported folder_id found inside yandex_kubernetes_node_group"
else
  ok "node group does not contain unsupported folder_id argument"
fi

terraform -chdir=terraform/environments/managed-kubernetes-cloud-run fmt -check -recursive && ok "terraform fmt check passed" || fail "terraform fmt check failed"

echo
echo "FAIL_COUNT=$FAIL_COUNT"

[ "$FAIL_COUNT" -eq 0 ] && exit 0 || exit 1
