#!/usr/bin/env bash
set -u

FAIL_COUNT=0

ok() {
  echo "[OK] $1"
}

fail() {
  echo "[FAIL] $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

need_file() {
  if [ -f "$1" ]; then
    ok "$1 exists"
  else
    fail "$1 missing"
  fi
}

need_grep() {
  pattern="$1"
  file="$2"
  label="$3"

  if grep -qE "$pattern" "$file"; then
    ok "$label"
  else
    fail "$label missing"
  fi
}

echo "YCSEC supply-chain package validator"
echo "Date: $(date -Is)"
echo

need_file supply-chain/demo-app/app.py
need_file supply-chain/demo-app/requirements-vulnerable.txt
need_file supply-chain/demo-app/requirements-remediated.txt
need_file supply-chain/demo-app/Dockerfile.insecure
need_file supply-chain/demo-app/Dockerfile.hardened
need_file policies/kyverno/supply-chain/registry-and-image-policy.yaml
need_file .github/workflows/supply-chain-oidc-registry-validation.yml
need_file scripts/run-supply-chain-local-evidence.sh

bash -n scripts/run-supply-chain-local-evidence.sh && ok "local evidence script syntax valid" || fail "local evidence script syntax invalid"

need_grep '^requests==2\.19\.1$' supply-chain/demo-app/requirements-vulnerable.txt "controlled vulnerable requests baseline present"
need_grep '^urllib3==1\.23$' supply-chain/demo-app/requirements-vulnerable.txt "controlled vulnerable urllib3 baseline present"
need_grep '^requests==2\.32\.3$' supply-chain/demo-app/requirements-remediated.txt "remediated requests target present"
need_grep '^urllib3==2\.2\.2$' supply-chain/demo-app/requirements-remediated.txt "remediated urllib3 target present"

need_grep '^FROM python:3\.9-slim-bullseye$' supply-chain/demo-app/Dockerfile.insecure "insecure baseline image present"
if grep -qE '^USER ' supply-chain/demo-app/Dockerfile.insecure; then
  fail "insecure Dockerfile unexpectedly defines non-root USER"
else
  ok "insecure Dockerfile intentionally runs as default root user"
fi

need_grep '^FROM python:3\.12-slim-bookworm$' supply-chain/demo-app/Dockerfile.hardened "hardened base image target present"
need_grep '^USER appuser$' supply-chain/demo-app/Dockerfile.hardened "hardened non-root user target present"

need_grep 'workflow_dispatch:' .github/workflows/supply-chain-oidc-registry-validation.yml "workflow_dispatch trigger present"
need_grep 'id-token: write' .github/workflows/supply-chain-oidc-registry-validation.yml "GitHub OIDC permission present"
need_grep 'https://auth\.yandex\.cloud/oauth/token' .github/workflows/supply-chain-oidc-registry-validation.yml "direct Yandex Cloud token exchange endpoint present"
need_grep 'docker login --username iam --password-stdin cr\.yandex' .github/workflows/supply-chain-oidc-registry-validation.yml "Yandex Container Registry IAM docker login present"
need_grep 'docker push' .github/workflows/supply-chain-oidc-registry-validation.yml "docker push step present"
need_grep 'YCSEC_MARKER_IMAGE_PUSH_OK' .github/workflows/supply-chain-oidc-registry-validation.yml "image push marker present"

need_grep 'validationFailureAction: Enforce' policies/kyverno/supply-chain/registry-and-image-policy.yaml "Kyverno enforce policy present"
need_grep 'cr\.yandex' policies/kyverno/supply-chain/registry-and-image-policy.yaml "Yandex Container Registry admission control present"
need_grep 'latest' policies/kyverno/supply-chain/registry-and-image-policy.yaml "mutable latest tag policy present"

if grep -RE "YC_SERVICE_ACCOUNT_KEY|authorized_key|service_account_key|json_key|credentials_json|key-file|yandex-cloud/yc-github-actions" .github/workflows/supply-chain-oidc-registry-validation.yml; then
  fail "rejected credential/action pattern found in workflow"
else
  ok "workflow avoids rejected credential/action patterns"
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
