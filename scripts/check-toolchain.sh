#!/usr/bin/env bash

OUT_DIR="${1:-evidence/command-outputs}"
OUT_FILE="${OUT_DIR}/YCSEC_04_OUTPUT_toolchain_check.txt"

mkdir -p "$OUT_DIR"

check_tool() {
  tool="$1"
  required="$2"

  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool found"
    case "$tool" in
      git) git --version 2>&1 | head -5 ;;
      jq) jq --version 2>&1 | head -5 ;;
      yq) yq --version 2>&1 | head -5 ;;
      yc) yc version 2>&1 | head -10 ;;
      tofu) tofu version 2>&1 | head -10 ;;
      terraform) terraform version 2>&1 | head -10 ;;
      kubectl) kubectl version --client=true 2>&1 | head -10 ;;
      helm) helm version 2>&1 | head -10 ;;
      docker) docker --version 2>&1 | head -5 ;;
      podman) podman --version 2>&1 | head -5 ;;
      kind) kind version 2>&1 | head -5 ;;
      k3d) k3d version 2>&1 | head -5 ;;
      trivy) trivy --version 2>&1 | head -10 ;;
      checkov) checkov --version 2>&1 | head -10 ;;
      gitleaks) gitleaks version 2>&1 | head -10 ;;
      semgrep) semgrep --version 2>&1 | head -10 ;;
      syft) syft version 2>&1 | head -10 ;;
      grype) grype version 2>&1 | head -10 ;;
      kube-score) kube-score version 2>&1 | head -10 ;;
      kubescape) kubescape version 2>&1 | head -10 ;;
      kyverno) kyverno version 2>&1 | head -10 ;;
      cosign) cosign version 2>&1 | head -10 ;;
      *) "$tool" --version 2>&1 | head -10 || true ;;
    esac
  else
    if [ "$required" = "required" ]; then
      echo "[WARN] $tool missing"
    else
      echo "[INFO] $tool optional or later-phase missing"
    fi
  fi

  echo
}

{
  echo "Phase 4 — Toolchain Check"
  echo "Date: $(date -Is)"
  echo "Qube: cloud-dev-workbench"
  echo

  echo "Core tools:"
  check_tool git required
  check_tool curl required
  check_tool wget optional
  check_tool unzip required
  check_tool tar required
  check_tool jq required
  check_tool yq optional
  check_tool python3 required
  check_tool pipx optional
  echo

  echo "Cloud and IaC tools:"
  check_tool yc required
  check_tool tofu required
  check_tool terraform optional
  echo

  echo "Kubernetes tools:"
  check_tool kubectl required
  check_tool helm optional
  check_tool kind optional
  check_tool k3d optional
  echo

  echo "Container tools:"
  check_tool podman optional
  check_tool docker optional
  echo

  echo "Security tools:"
  check_tool gitleaks required
  check_tool checkov required
  check_tool trivy required
  check_tool semgrep optional
  check_tool syft optional
  check_tool grype optional
  check_tool kube-score optional
  check_tool kubescape optional
  check_tool kyverno optional
  check_tool cosign optional
  echo

  echo "Git status:"
  git status --short 2>/dev/null || true
} | tee "$OUT_FILE"

echo "[OK] toolchain check evidence saved: $OUT_FILE"
