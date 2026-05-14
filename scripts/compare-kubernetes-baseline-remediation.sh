#!/usr/bin/env bash

echo "YCSEC Kubernetes Before/After Remediation Comparison"
echo "Date: $(date -Is)"
echo

FAIL_COUNT=0

BASELINE_ROOTS=()
for d in kubernetes k8s manifests; do
  if test -d "$d"; then
    BASELINE_ROOTS+=("$d")
  fi
done

REMEDIATION_ROOTS=(
  kubernetes/remediation
  policies/kyverno
)

for d in "${REMEDIATION_ROOTS[@]}"; do
  if test ! -d "$d"; then
    echo "[FAIL] remediation root missing: $d"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

if test "$FAIL_COUNT" -ne 0; then
  echo "[FAIL] required remediation roots are missing"
  exit 1
fi

count_pattern() {
  roots="$1"
  pattern="$2"

  grep -RIlE "$pattern" $roots 2>/dev/null | wc -l
}

count_files() {
  roots="$1"

  find $roots -type f \( -iname "*.yaml" -o -iname "*.yml" \) -print 2>/dev/null | wc -l
}

BASELINE_ROOT_STRING="${BASELINE_ROOTS[*]}"
REMEDIATION_ROOT_STRING="${REMEDIATION_ROOTS[*]}"

BASE_MANIFESTS="$(count_files "$BASELINE_ROOT_STRING")"
REM_MANIFESTS="$(count_files "$REMEDIATION_ROOT_STRING")"

BASE_POD_SECURITY="$(count_pattern "$BASELINE_ROOT_STRING" 'pod-security.kubernetes.io/(enforce|audit|warn):[[:space:]]*restricted')"
REM_POD_SECURITY="$(count_pattern "$REMEDIATION_ROOT_STRING" 'pod-security.kubernetes.io/(enforce|audit|warn):[[:space:]]*restricted')"

BASE_RUN_AS_NON_ROOT="$(count_pattern "$BASELINE_ROOT_STRING" 'runAsNonRoot:[[:space:]]*true')"
REM_RUN_AS_NON_ROOT="$(count_pattern "$REMEDIATION_ROOT_STRING" 'runAsNonRoot:[[:space:]]*true')"

BASE_NO_PRIV_ESC="$(count_pattern "$BASELINE_ROOT_STRING" 'allowPrivilegeEscalation:[[:space:]]*false')"
REM_NO_PRIV_ESC="$(count_pattern "$REMEDIATION_ROOT_STRING" 'allowPrivilegeEscalation:[[:space:]]*false')"

BASE_DROP_CAPS="$(count_pattern "$BASELINE_ROOT_STRING" 'capabilities:|drop:[[:space:]]*\[?ALL\]?|ALL')"
REM_DROP_CAPS="$(count_pattern "$REMEDIATION_ROOT_STRING" 'capabilities:|drop:[[:space:]]*\[?ALL\]?|ALL')"

BASE_SECCOMP="$(count_pattern "$BASELINE_ROOT_STRING" 'seccompProfile:|type:[[:space:]]*RuntimeDefault')"
REM_SECCOMP="$(count_pattern "$REMEDIATION_ROOT_STRING" 'seccompProfile:|type:[[:space:]]*RuntimeDefault')"

BASE_READONLY_FS="$(count_pattern "$BASELINE_ROOT_STRING" 'readOnlyRootFilesystem:[[:space:]]*true')"
REM_READONLY_FS="$(count_pattern "$REMEDIATION_ROOT_STRING" 'readOnlyRootFilesystem:[[:space:]]*true')"

BASE_RBAC="$(count_pattern "$BASELINE_ROOT_STRING" 'kind:[[:space:]]*(ServiceAccount|Role|RoleBinding|ClusterRole|ClusterRoleBinding)')"
REM_RBAC="$(count_pattern "$REMEDIATION_ROOT_STRING" 'kind:[[:space:]]*(ServiceAccount|Role|RoleBinding|ClusterRole|ClusterRoleBinding)')"

BASE_NETPOL="$(count_pattern "$BASELINE_ROOT_STRING" 'kind:[[:space:]]*NetworkPolicy')"
REM_NETPOL="$(count_pattern "$REMEDIATION_ROOT_STRING" 'kind:[[:space:]]*NetworkPolicy')"

BASE_CLUSTERIP="$(count_pattern "$BASELINE_ROOT_STRING" 'type:[[:space:]]*ClusterIP')"
REM_CLUSTERIP="$(count_pattern "$REMEDIATION_ROOT_STRING" 'type:[[:space:]]*ClusterIP')"

BASE_RESOURCES="$(count_pattern "$BASELINE_ROOT_STRING" 'requests:|limits:')"
REM_RESOURCES="$(count_pattern "$REMEDIATION_ROOT_STRING" 'requests:|limits:')"

BASE_POLICY="$(count_pattern "$BASELINE_ROOT_STRING" 'kind:[[:space:]]*(ClusterPolicy|Policy)|kyverno|opa|gatekeeper|ConstraintTemplate|conftest|rego')"
REM_POLICY="$(count_pattern "$REMEDIATION_ROOT_STRING" 'kind:[[:space:]]*(ClusterPolicy|Policy)|kyverno|opa|gatekeeper|ConstraintTemplate|conftest|rego')"

echo "Before/after metrics"
echo "Metric|Baseline|Remediation|Delta"
echo "Kubernetes manifests|$BASE_MANIFESTS|$REM_MANIFESTS|$((REM_MANIFESTS - BASE_MANIFESTS))"
echo "Restricted Pod Security labels|$BASE_POD_SECURITY|$REM_POD_SECURITY|$((REM_POD_SECURITY - BASE_POD_SECURITY))"
echo "runAsNonRoot|$BASE_RUN_AS_NON_ROOT|$REM_RUN_AS_NON_ROOT|$((REM_RUN_AS_NON_ROOT - BASE_RUN_AS_NON_ROOT))"
echo "allowPrivilegeEscalation false|$BASE_NO_PRIV_ESC|$REM_NO_PRIV_ESC|$((REM_NO_PRIV_ESC - BASE_NO_PRIV_ESC))"
echo "Capabilities/drop ALL|$BASE_DROP_CAPS|$REM_DROP_CAPS|$((REM_DROP_CAPS - BASE_DROP_CAPS))"
echo "RuntimeDefault seccomp|$BASE_SECCOMP|$REM_SECCOMP|$((REM_SECCOMP - BASE_SECCOMP))"
echo "readOnlyRootFilesystem|$BASE_READONLY_FS|$REM_READONLY_FS|$((REM_READONLY_FS - BASE_READONLY_FS))"
echo "RBAC objects|$BASE_RBAC|$REM_RBAC|$((REM_RBAC - BASE_RBAC))"
echo "NetworkPolicy objects|$BASE_NETPOL|$REM_NETPOL|$((REM_NETPOL - BASE_NETPOL))"
echo "ClusterIP Service exposure|$BASE_CLUSTERIP|$REM_CLUSTERIP|$((REM_CLUSTERIP - BASE_CLUSTERIP))"
echo "Resource requests/limits|$BASE_RESOURCES|$REM_RESOURCES|$((REM_RESOURCES - BASE_RESOURCES))"
echo "Policy-as-code controls|$BASE_POLICY|$REM_POLICY|$((REM_POLICY - BASE_POLICY))"
echo

echo "Risk regression check"
REGRESSION_COUNT=0

if grep -RInE 'type:[[:space:]]*LoadBalancer' "${REMEDIATION_ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] LoadBalancer exposure detected after remediation"
  REGRESSION_COUNT=$((REGRESSION_COUNT + 1))
else
  echo "[OK] no LoadBalancer exposure after remediation"
fi

if grep -RInE 'privileged:[[:space:]]*true' "${REMEDIATION_ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] privileged container detected after remediation"
  REGRESSION_COUNT=$((REGRESSION_COUNT + 1))
else
  echo "[OK] no privileged containers after remediation"
fi

if grep -RInE 'hostNetwork:[[:space:]]*true' "${REMEDIATION_ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] hostNetwork detected after remediation"
  REGRESSION_COUNT=$((REGRESSION_COUNT + 1))
else
  echo "[OK] no hostNetwork after remediation"
fi

if grep -RInE 'hostPath:' "${REMEDIATION_ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] hostPath detected after remediation"
  REGRESSION_COUNT=$((REGRESSION_COUNT + 1))
else
  echo "[OK] no hostPath after remediation"
fi

if grep -RInE 'image:[[:space:]].*:latest' "${REMEDIATION_ROOTS[@]}" 2>/dev/null; then
  echo "[FAIL] latest image tag detected after remediation"
  REGRESSION_COUNT=$((REGRESSION_COUNT + 1))
else
  echo "[OK] no latest image tags after remediation"
fi

echo
echo "Comparison summary"
echo "REGRESSION_COUNT=$REGRESSION_COUNT"

if test "$REGRESSION_COUNT" -eq 0; then
  echo "[OK] before/after comparison completed without remediation regressions"
else
  echo "[FAIL] remediation regressions detected"
  exit 1
fi
