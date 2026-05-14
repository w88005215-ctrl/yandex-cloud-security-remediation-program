#!/usr/bin/env bash
set -u -o pipefail

echo "YCSEC supply-chain package validator"
echo "Date: $(date -Is)"
echo

FAIL_COUNT=0

ok() { echo "[OK] $1"; }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

need_file() {
  if [ -f "$1" ]; then
    ok "$1 exists"
  else
    fail "$1 missing"
  fi
}

need_file "supply-chain/demo-app/app.py"
need_file "supply-chain/demo-app/requirements-vulnerable.txt"
need_file "supply-chain/demo-app/requirements-remediated.txt"
need_file "supply-chain/demo-app/Dockerfile.insecure"
need_file "supply-chain/demo-app/Dockerfile.hardened"
need_file "policies/kyverno/supply-chain/registry-and-image-policy.yaml"
need_file ".github/workflows/supply-chain-oidc-registry-validation.yml"
need_file "scripts/run-supply-chain-local-evidence.sh"

bash -n scripts/run-supply-chain-local-evidence.sh && ok "local evidence script syntax valid" || fail "local evidence script syntax invalid"

if grep -qE "Flask==1\.0|Jinja2==2\.10|requests==2\.19\.1|urllib3==1\.24\.1|PyYAML==5\.3\.1" supply-chain/demo-app/requirements-vulnerable.txt; then
  ok "controlled vulnerable dependency baseline present"
else
  fail "controlled vulnerable dependency baseline missing"
fi

if grep -q "USER root" supply-chain/demo-app/Dockerfile.insecure; then
  ok "insecure root image baseline present"
else
  fail "insecure root image baseline missing"
fi

if grep -q "USER appuser" supply-chain/demo-app/Dockerfile.hardened; then
  ok "hardened non-root image target present"
else
  fail "hardened non-root image target missing"
fi

if grep -q "workflow_dispatch" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  ok "workflow_dispatch trigger present"
else
  fail "workflow_dispatch trigger missing"
fi

if grep -q "id-token: write" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  ok "GitHub OIDC permission present"
else
  fail "GitHub OIDC permission missing"
fi

if grep -q "auth.yandex.cloud/oauth/token" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  ok "direct Yandex Cloud token exchange endpoint present"
else
  fail "direct Yandex Cloud token exchange endpoint missing"
fi

if grep -q "docker login --username iam --password-stdin cr.yandex" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  ok "Yandex Container Registry IAM docker login present"
else
  fail "Yandex Container Registry IAM docker login missing"
fi

if grep -q "YCSEC_YCR_REGISTRY_ID" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  ok "registry id variable reference present"
else
  fail "registry id variable reference missing"
fi

if grep -q "validationFailureAction: Enforce" policies/kyverno/supply-chain/registry-and-image-policy.yaml; then
  ok "Kyverno enforce policy present"
else
  fail "Kyverno enforce policy missing"
fi

if grep -q "cr.yandex" policies/kyverno/supply-chain/registry-and-image-policy.yaml; then
  ok "Yandex Container Registry admission control present"
else
  fail "Yandex Container Registry admission control missing"
fi

if grep -q "disallow-latest-tag" policies/kyverno/supply-chain/registry-and-image-policy.yaml; then
  ok "mutable latest tag denial policy present"
else
  fail "mutable latest tag denial policy missing"
fi

echo
echo "FAIL_COUNT=$FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
  ok "supply-chain package validation passed"
  exit 0
else
  fail "supply-chain package validation failed"
  exit 1
fi
