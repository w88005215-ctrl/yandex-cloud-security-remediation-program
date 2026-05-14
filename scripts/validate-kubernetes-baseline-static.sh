#!/usr/bin/env bash

echo "YCSEC Kubernetes Baseline Static Validator"
echo "Date: $(date -Is)"
echo

VALIDATION_WARNINGS=0
VALIDATION_FINDINGS=0

ROOTS=()
for d in kubernetes k8s manifests policies policy-as-code; do
  if test -d "$d"; then
    ROOTS+=("$d")
  fi
done

if test "${#ROOTS[@]}" -eq 0; then
  echo "[FAIL] no Kubernetes manifest roots found"
  exit 1
fi

echo "Manifest roots:"
for d in "${ROOTS[@]}"; do
  echo "- $d"
done
echo

MANIFESTS="$(find "${ROOTS[@]}" -type f \( -iname "*.yaml" -o -iname "*.yml" \) -print 2>/dev/null | sort || true)"
MANIFEST_COUNT="$(printf "%s\n" "$MANIFESTS" | sed '/^$/d' | wc -l)"

echo "Manifest count: $MANIFEST_COUNT"

if test "$MANIFEST_COUNT" -eq 0; then
  echo "[FAIL] no Kubernetes YAML manifests found"
  exit 1
fi

echo
echo "Object inventory"
echo "Namespaces: $(grep -RIlE 'kind:[[:space:]]*Namespace' "${ROOTS[@]}" 2>/dev/null | wc -l)"
echo "Workloads: $(grep -RIlE 'kind:[[:space:]]*(Deployment|Pod|StatefulSet|DaemonSet)' "${ROOTS[@]}" 2>/dev/null | wc -l)"
echo "Services: $(grep -RIlE 'kind:[[:space:]]*Service' "${ROOTS[@]}" 2>/dev/null | wc -l)"
echo "ServiceAccounts/RBAC: $(grep -RIlE 'kind:[[:space:]]*(ServiceAccount|Role|ClusterRole|RoleBinding|ClusterRoleBinding)' "${ROOTS[@]}" 2>/dev/null | wc -l)"
echo "NetworkPolicies: $(grep -RIlE 'kind:[[:space:]]*NetworkPolicy' "${ROOTS[@]}" 2>/dev/null | wc -l)"
echo

echo "Control checks"

check_control() {
  control_id="$1"
  description="$2"
  pattern="$3"
  severity="$4"

  matches="$(grep -RIlE "$pattern" "${ROOTS[@]}" 2>/dev/null | wc -l)"

  if test "$matches" -gt 0; then
    echo "[OK] $control_id — $description — matches: $matches"
  else
    echo "[FINDING][$severity] $control_id — $description — no matching control evidence found"
    VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
  fi
}

check_control "K8S-BASE-001" "namespace isolation objects" 'kind:[[:space:]]*Namespace' "MEDIUM"
check_control "K8S-BASE-002" "Pod Security labels" 'pod-security.kubernetes.io' "HIGH"
check_control "K8S-BASE-003" "non-root execution" 'runAsNonRoot:[[:space:]]*true' "HIGH"
check_control "K8S-BASE-004" "privilege escalation disabled" 'allowPrivilegeEscalation:[[:space:]]*false' "HIGH"
check_control "K8S-BASE-005" "Linux capabilities constrained" 'capabilities:|drop:[[:space:]]*\[?ALL\]?' "HIGH"
check_control "K8S-BASE-006" "RuntimeDefault seccomp profile" 'seccompProfile:|type:[[:space:]]*RuntimeDefault' "MEDIUM"
check_control "K8S-BASE-007" "read-only root filesystem" 'readOnlyRootFilesystem:[[:space:]]*true' "MEDIUM"
check_control "K8S-BASE-008" "RBAC objects" 'kind:[[:space:]]*(ServiceAccount|Role|ClusterRole|RoleBinding|ClusterRoleBinding)' "MEDIUM"
check_control "K8S-BASE-009" "NetworkPolicy segmentation" 'kind:[[:space:]]*NetworkPolicy' "HIGH"
check_control "K8S-BASE-010" "service exposure objects" 'kind:[[:space:]]*Service' "LOW"
check_control "K8S-BASE-011" "resource requests and limits" 'requests:|limits:' "MEDIUM"
check_control "K8S-BASE-012" "policy-as-code references" 'kind:[[:space:]]*(ClusterPolicy|Policy)|kyverno|opa|gatekeeper|ConstraintTemplate|conftest|rego' "MEDIUM"

echo
echo "Potential risk indicators"

LB_SERVICES="$(grep -RInE 'type:[[:space:]]*LoadBalancer' "${ROOTS[@]}" 2>/dev/null || true)"
PRIVILEGED_TRUE="$(grep -RInE 'privileged:[[:space:]]*true' "${ROOTS[@]}" 2>/dev/null || true)"
HOST_NETWORK="$(grep -RInE 'hostNetwork:[[:space:]]*true' "${ROOTS[@]}" 2>/dev/null || true)"
HOST_PATH="$(grep -RInE 'hostPath:' "${ROOTS[@]}" 2>/dev/null || true)"
LATEST_TAGS="$(grep -RInE 'image:[[:space:]].*:latest' "${ROOTS[@]}" 2>/dev/null || true)"

if test -n "$LB_SERVICES"; then
  echo "[FINDING][HIGH] Service type LoadBalancer detected"
  echo "$LB_SERVICES"
  VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
else
  echo "[OK] no Service type LoadBalancer detected"
fi

if test -n "$PRIVILEGED_TRUE"; then
  echo "[FINDING][CRITICAL] privileged containers detected"
  echo "$PRIVILEGED_TRUE"
  VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
else
  echo "[OK] no privileged containers detected"
fi

if test -n "$HOST_NETWORK"; then
  echo "[FINDING][HIGH] hostNetwork usage detected"
  echo "$HOST_NETWORK"
  VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
else
  echo "[OK] no hostNetwork usage detected"
fi

if test -n "$HOST_PATH"; then
  echo "[FINDING][HIGH] hostPath volume usage detected"
  echo "$HOST_PATH"
  VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
else
  echo "[OK] no hostPath volume usage detected"
fi

if test -n "$LATEST_TAGS"; then
  echo "[FINDING][MEDIUM] image latest tag usage detected"
  echo "$LATEST_TAGS"
  VALIDATION_FINDINGS=$((VALIDATION_FINDINGS + 1))
else
  echo "[OK] no latest image tags detected"
fi

echo
echo "Validation summary"
echo "Findings: $VALIDATION_FINDINGS"
echo "Warnings: $VALIDATION_WARNINGS"

if test "$VALIDATION_FINDINGS" -gt 0; then
  echo "[OK] baseline validation completed with findings"
  echo "[OK] findings are expected at baseline stage and will drive remediation"
else
  echo "[OK] baseline validation completed with no findings"
  echo "[WARN] no findings may reduce before/after remediation value"
fi
