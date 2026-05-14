#!/usr/bin/env bash
set -u -o pipefail

echo "YCSEC Phase 13.2 — local supply-chain evidence helper"
echo "Date: $(date -Is)"
echo "Qube: $(hostname)"
echo

OUT_DIR="evidence/supply-chain/local"
APP_DIR="supply-chain/demo-app"

mkdir -p "$OUT_DIR"

WARN_COUNT=0
FAIL_COUNT=0

ok() { echo "[OK] $1"; }
warn() { echo "[WARN] $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

need_file() {
  if [ -f "$1" ]; then
    ok "$1 exists"
  else
    fail "$1 missing"
  fi
}

need_file "$APP_DIR/app.py"
need_file "$APP_DIR/requirements-vulnerable.txt"
need_file "$APP_DIR/requirements-remediated.txt"
need_file "$APP_DIR/Dockerfile.insecure"
need_file "$APP_DIR/Dockerfile.hardened"

echo
echo "Tool availability"
for tool in syft grype trivy; do
  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool available"
  else
    warn "$tool not available; related evidence will be skipped"
  fi
done

echo
echo "SBOM generation"
if command -v syft >/dev/null 2>&1; then
  syft "dir:$APP_DIR" -o cyclonedx-json > "$OUT_DIR/sbom_demo_app_cyclonedx.json" 2> "$OUT_DIR/syft_stderr.txt"
  if [ "$?" -eq 0 ]; then
    ok "CycloneDX SBOM generated: $OUT_DIR/sbom_demo_app_cyclonedx.json"
  else
    warn "syft returned non-zero; review $OUT_DIR/syft_stderr.txt"
  fi
fi

echo
echo "Vulnerability scan evidence"
if command -v grype >/dev/null 2>&1; then
  grype "dir:$APP_DIR" -o table > "$OUT_DIR/grype_demo_app_scan.txt" 2> "$OUT_DIR/grype_stderr.txt"
  if [ "$?" -eq 0 ]; then
    ok "grype scan completed without findings threshold failure"
  else
    warn "grype returned non-zero; this can be expected when vulnerabilities are detected"
  fi
fi

if command -v trivy >/dev/null 2>&1; then
  trivy fs --scanners vuln,misconfig,secret "$APP_DIR" > "$OUT_DIR/trivy_demo_app_fs_scan.txt" 2> "$OUT_DIR/trivy_stderr.txt"
  if [ "$?" -eq 0 ]; then
    ok "trivy filesystem scan completed without findings threshold failure"
  else
    warn "trivy returned non-zero; this can be expected when vulnerabilities are detected"
  fi
fi

echo
echo "Evidence summary"
cat > "$OUT_DIR/supply_chain_local_evidence_summary.txt" <<SUMMARY
YCSEC supply-chain local evidence summary
Date: $(date -Is)

Generated/expected evidence:
- $OUT_DIR/sbom_demo_app_cyclonedx.json
- $OUT_DIR/grype_demo_app_scan.txt
- $OUT_DIR/trivy_demo_app_fs_scan.txt

Warnings: $WARN_COUNT
Failures: $FAIL_COUNT

Notes:
- Non-zero scanner exit codes may indicate detected vulnerabilities, not script failure.
- This helper does not create cloud resources.
- Registry push validation is handled by the Phase 13.3 GitHub Actions/OIDC workflow stage.
SUMMARY

ok "local evidence summary written: $OUT_DIR/supply_chain_local_evidence_summary.txt"

echo
echo "Final decision"
echo "WARN_COUNT=$WARN_COUNT"
echo "FAIL_COUNT=$FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
  ok "local supply-chain evidence helper completed"
  exit 0
else
  fail "local supply-chain evidence helper contains blocking failures"
  exit 1
fi
