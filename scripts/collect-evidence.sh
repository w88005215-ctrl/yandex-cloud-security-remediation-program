#!/usr/bin/env bash

OUT_DIR="${1:-evidence/command-outputs}"
OUT_FILE="${OUT_DIR}/YCSEC_03_OUTPUT_tool_versions.txt"

mkdir -p "$OUT_DIR"

{
  echo "YCSEC Tool Version Inventory"
  echo "Date: $(date -Is)"
  echo "Qube: cloud-dev-workbench"
  echo

  echo "Git repository:"
  git rev-parse --show-toplevel 2>/dev/null || true
  echo

  echo "Git status:"
  git status --short 2>/dev/null || true
  echo

  echo "Tool versions:"
  echo

  for tool in git yc terraform tofu kubectl helm jq yq docker podman kind k3d trivy checkov gitleaks semgrep syft grype kube-score kubescape kyverno cosign; do
    if command -v "$tool" >/dev/null 2>&1; then
      echo "[$tool]"
      "$tool" version 2>&1 | head -20 || "$tool" --version 2>&1 | head -20 || true
      echo
    else
      echo "[$tool]"
      echo "not installed"
      echo
    fi
  done
} | tee "$OUT_FILE"

echo "[OK] evidence saved: $OUT_FILE"
