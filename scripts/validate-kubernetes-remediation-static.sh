#!/usr/bin/env bash

echo "YCSEC Kubernetes Remediation Static Validator"
echo "Date: $(date -Is)"
echo

FAIL_COUNT=0
WARN_COUNT=0

ROOTS=(
  kubernetes/remediation
  policies/kyverno
)

for d in "${ROOTS[@]}"; do
  if test -d "$d"; then
    echo "[OK] remediation root exists: $d"
  else
    echo "[FAIL] remediation root missing: $d"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

echo

check_required_pattern() {
  control_id="$1"
  description="$2"
  pattern="$3"
  roots="${ROOTS[*]}"

  matches="$(grep -RIlE "$pattern" $roots 2>/dev/null | wc -l)"

  if test "$matches" -gt 0; then
    echo "[OK] $control_id — $description — matches: $matches"
  else
    echo "[FAIL] $control_id — $description — no remediation evidence found"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

check_required_pattern "K8S-REM-001" "restricted namespace Pod Security labels" 'pod-security.kubernetes.io/(enforce|audit|warn):[[:space:]]*restricted'
check_required_pattern "K8S-REM-002" "non-root execution" 'runAsNonRoot:[[:space:]]*true'
check_required_pattern "K8S-REM-003" "privilege escalation disabled" 'allowPrivilegeEscalation:[[:space:]]*false'
check_required_pattern "K8S-REM-004" "Linux capabilities dropped" 'drop:|ALL'
check_required_pattern "K8S-REM-005" "RuntimeDefault seccomp profile" 'seccompProfile:|type:[[:space:]]*RuntimeDefault'
check_required_pattern "K8S-REM-006" "read-only root filesystem" 'readOnlyRootFilesystem:[[:space:]]*true'
check_required_pattern "K8S-REM-007" "resource requests and limits" 'requests:|limits:'
check_required_pattern "K8S-REM-008" "least-privilege RBAC objects" 'kind:[[:space:]]*(ServiceAccount|Role|RoleBinding)'
check_required_pattern "K8S-REM-009" "NetworkPolicy segmentation" 'kind:[[:space:]]*NetworkPolicy'
check_required_pattern "K8S-REM-010" "ClusterIP-only Service exposure" 'type:[[:space:]]*ClusterIP'
check_required_pattern "K8S-REM-011" "policy-as-code control package" 'kind:[[:space:]]*ClusterPolicy|kyverno.io/v1'
check_required_pattern "K8S-REM-012" "service account token automount disabled" 'automountServiceAccountToken:[[:space:]]*false'

echo
echo "Risk regression checks"

if grep -RInE 'type:[[:space:]]*LoadBalancer' "${ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] LoadBalancer exposure detected in remediation package"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] no LoadBalancer exposure detected"
fi

if grep -RInE 'privileged:[[:space:]]*true' "${ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] privileged container detected in remediation package"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] no privileged containers detected"
fi

if grep -RInE 'hostNetwork:[[:space:]]*true' "${ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] hostNetwork usage detected in remediation package"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] no hostNetwork usage detected"
fi

if grep -RInE 'hostPath:' "${ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] hostPath usage detected in remediation package"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] no hostPath usage detected"
fi

if grep -RInE 'image:[[:space:]].*:latest' "${ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] latest image tag detected in remediation package"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] no latest image tags detected"
fi

echo
echo "Remediation validation summary"
echo "WARN_COUNT=$WARN_COUNT"
echo "FAIL_COUNT=$FAIL_COUNT"

if test "$FAIL_COUNT" -eq 0; then
  echo "[OK] remediation static validation passed"
else
  echo "[FAIL] remediation static validation failed"
fi
