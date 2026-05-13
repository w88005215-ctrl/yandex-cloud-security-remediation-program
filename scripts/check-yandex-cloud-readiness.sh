#!/usr/bin/env bash
set -u

echo "YCSEC Phase 10 — Yandex Cloud Readiness Gate"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

BLOCKERS=0

ok() { echo "[OK] $1"; }
fail() { echo "[FAIL] $1"; BLOCKERS=$((BLOCKERS + 1)); }

echo "Tool checks"
if command -v yc >/dev/null 2>&1; then
  ok "yc -> $(command -v yc)"
  yc version 2>&1 | head -n 3
else
  fail "yc missing"
fi
echo

echo "YC profile read-only checks"
CLOUD_ID="$(yc config get cloud-id 2>/dev/null || true)"
FOLDER_ID="$(yc config get folder-id 2>/dev/null || true)"

if test -n "$CLOUD_ID"; then
  ok "cloud-id is configured"
else
  fail "cloud-id is not configured"
fi

if test -n "$FOLDER_ID"; then
  ok "folder-id is configured"
else
  fail "folder-id is not configured"
fi
echo

echo "Resource Manager read-only checks"
if test -n "$CLOUD_ID"; then
  echo
  echo "Cloud lookup:"
  if yc resource-manager cloud get "$CLOUD_ID" 2>&1 | sed -E 's/(token|secret|key):.*/\1: REDACTED/Ig'; then
    ok "cloud lookup succeeded"
  else
    fail "cloud lookup failed"
  fi
fi

if test -n "$FOLDER_ID"; then
  echo
  echo "Folder lookup:"
  if yc resource-manager folder get "$FOLDER_ID" 2>&1 | sed -E 's/(token|secret|key):.*/\1: REDACTED/Ig'; then
    ok "folder lookup succeeded"
  else
    fail "folder lookup failed"
  fi
fi
echo

echo "Terraform variable readiness"
for env_dir in terraform/environments/bootstrap terraform/environments/dev terraform/environments/prod-like; do
  if test -s "$env_dir/terraform.tfvars.example"; then
    ok "$env_dir/terraform.tfvars.example exists"
  else
    fail "$env_dir/terraform.tfvars.example missing"
  fi
done
echo

echo "Sensitive file checks"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && fail "Terraform state files found" || ok "No Terraform state files"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && fail "kubeconfig-like files found" || ok "No kubeconfig files"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && fail "key/token-like files found" || ok "No key/token-like files"
echo

echo "Read-only boundary"
ok "only yc config get was used for profile values"
ok "only yc resource-manager get operations were used"
ok "no yc create/update/delete operation is part of this gate"
ok "no terraform apply is part of this gate"
echo

echo "Readiness summary"
if test "$BLOCKERS" -eq 0; then
  ok "Yandex Cloud readiness gate passed"
  exit 0
else
  fail "Yandex Cloud readiness gate has $BLOCKERS blocker(s)"
  exit 1
fi
