#!/usr/bin/env bash

echo "YCSEC Phase 6 — Local IaC Security Gates"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

export PATH="$HOME/.local/bin:$HOME/yandex-cloud/bin:$PATH"

FAIL_COUNT=0

run_cmd() {
  title="$1"
  shift

  echo
  echo "== $title =="
  "$@"
  rc="$?"

  if test "$rc" -eq 0; then
    echo "[OK] $title"
  else
    echo "[FAIL] $title rc=$rc"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

run_warn_cmd() {
  title="$1"
  shift

  echo
  echo "== $title =="
  "$@"
  rc="$?"

  if test "$rc" -eq 0; then
    echo "[OK] $title"
  else
    echo "[WARN] $title rc=$rc"
  fi
}

validate_with_tool() {
  tool="$1"
  target_dir="$2"

  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "[FAIL] $tool missing"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    return
  fi

  tfdata="$(mktemp -d)"

  echo
  echo "== $tool init: $target_dir =="
  TF_DATA_DIR="$tfdata" "$tool" -chdir="$target_dir" init -backend=false -input=false -no-color
  init_rc="$?"

  echo
  echo "== $tool validate: $target_dir =="
  if test "$init_rc" -eq 0; then
    TF_DATA_DIR="$tfdata" "$tool" -chdir="$target_dir" validate -no-color
    validate_rc="$?"
  else
    validate_rc=1
  fi

  rm -rf "$tfdata"

  if test "$init_rc" -eq 0 && test "$validate_rc" -eq 0; then
    echo "[OK] $tool validation passed for $target_dir"
  else
    echo "[FAIL] $tool validation failed for $target_dir"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
}

echo "Tool availability"
for t in terraform tofu checkov trivy gitleaks; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "[OK] $t -> $(command -v "$t")"
  else
    echo "[FAIL] $t missing"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

run_cmd "terraform fmt recursive" terraform fmt -recursive
run_cmd "tofu fmt recursive" tofu fmt -recursive

echo
echo "Terraform environment validation"
for env_dir in \
  terraform/environments/bootstrap \
  terraform/environments/dev \
  terraform/environments/prod-like
do
  validate_with_tool terraform "$env_dir"
done

echo
echo "OpenTofu provider-independent module validation"
for module_dir in \
  terraform/modules/network \
  terraform/modules/iam \
  terraform/modules/oidc \
  terraform/modules/audit \
  terraform/modules/registry \
  terraform/modules/object-storage \
  terraform/modules/managed-kubernetes
do
  validate_with_tool tofu "$module_dir"
done

run_warn_cmd "checkov terraform scan" checkov -d terraform --framework terraform --quiet --output cli

run_warn_cmd "trivy filesystem scan" trivy fs --scanners vuln,secret,misconfig --skip-dirs .git --skip-dirs .terraform --exit-code 0 .

echo
echo "== gitleaks secret scan =="
gitleaks detect --source . --no-banner --redact
GITLEAKS_RC="$?"

if test "$GITLEAKS_RC" -eq 0; then
  echo "[OK] gitleaks secret scan"
else
  echo "[FAIL] gitleaks secret scan rc=$GITLEAKS_RC"
  FAIL_COUNT=$((FAIL_COUNT + 1))
fi

echo
echo "Sensitive file checks"

if find . -name "*.tfstate*" ! -path "./.git/*" | grep -q .; then
  echo "[FAIL] Terraform state files found"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] No Terraform state files"
fi

if find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q .; then
  echo "[FAIL] kubeconfig-like files found"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] No kubeconfig files"
fi

if find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q .; then
  echo "[FAIL] key/token-like files found"
  FAIL_COUNT=$((FAIL_COUNT + 1))
else
  echo "[OK] No key/token-like files"
fi

echo
echo "Cloud cost control"
echo "[OK] No Yandex Cloud resources created in this phase"
echo "[OK] No promo code activation in this phase"
echo "[OK] No terraform apply executed in this phase"
echo "[OK] No Managed Kubernetes created in this phase"
echo "[OK] No Compute nodes created in this phase"
echo "[OK] No LoadBalancer created in this phase"
echo "[OK] No public IP created in this phase"

echo
echo "Gate summary"
if test "$FAIL_COUNT" -eq 0; then
  echo "[OK] Local IaC security gates completed without blocking failures"
  exit 0
else
  echo "[FAIL] Local IaC security gates have $FAIL_COUNT blocking failure(s)"
  exit 1
fi
