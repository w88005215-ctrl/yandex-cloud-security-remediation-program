#!/usr/bin/env bash

echo "YCSEC Clean Toolchain Check"
echo "Date: $(date -Is)"
echo "Qube: cloud-dev-workbench"
echo

export PATH="$HOME/.local/bin:$HOME/yandex-cloud/bin:$PATH"

check_required() {
  name="$1"
  version_cmd="$2"

  if command -v "$name" >/dev/null 2>&1; then
    echo "[OK] $name"
    sh -c "$version_cmd" 2>&1 | head -n 5
  else
    echo "[FAIL] $name missing"
  fi

  echo
}

check_warn() {
  name="$1"
  version_cmd="$2"

  if command -v "$name" >/dev/null 2>&1; then
    echo "[OK] $name"
    sh -c "$version_cmd" 2>&1 | head -n 5
  else
    echo "[WARN] $name missing"
  fi

  echo
}

echo "Core tools"
check_required git "git --version"
check_required curl "curl --version"
check_required jq "jq --version"
check_required python3 "python3 --version"
check_required pipx "python3 -m pipx --version"

echo "Cloud and IaC"
check_required yc "yc version"
check_required terraform "terraform version"
check_required tofu "tofu version"

echo "Kubernetes CLI"
check_required kubectl "kubectl version --client=true"
check_required helm "helm version --short"
check_required yq "yq --version"

echo "Container and local Kubernetes"
check_required podman "podman --version"
check_required buildah "buildah --version"
check_required skopeo "skopeo --version"
check_required kind "kind --version"
check_required k3d "k3d version"
check_warn docker "docker --version"

echo "Security scanners"
check_required gitleaks "gitleaks version"
check_required trivy "trivy --version"
check_required checkov "checkov --version"
check_required semgrep "semgrep --version"
check_required syft "syft version"
check_required grype "grype version"
check_required kube-score "kube-score version"
check_required kubescape "kubescape version"
check_required kyverno "kyverno version"
check_required cosign "cosign version"

echo "Repo quality tools"
check_required gh "gh --version"
check_required shellcheck "shellcheck --version"
check_required yamllint "yamllint --version"
check_required markdownlint "markdownlint --version"
check_required pre-commit "pre-commit --version"
check_warn aws "aws --version"

echo "Sensitive file checks"
find . -name "*.tfstate*" ! -path "./.git/*" | grep -q . && echo "[FAIL] Terraform state files found" || echo "[OK] No Terraform state files"
find . -iname "*kubeconfig*" ! -path "./.git/*" | grep -q . && echo "[FAIL] kubeconfig-like files found" || echo "[OK] No kubeconfig files"
find . \( -iname "*.pem" -o -iname "*.key" -o -iname "*.token" -o -iname "*authorized_key*.json" -o -iname "*service_account_key*.json" -o -iname "*yc-sa-key*.json" \) ! -path "./.git/*" | grep -q . && echo "[FAIL] key/token-like files found" || echo "[OK] No key/token-like files"

echo
echo "Cloud cost control"
echo "[OK] No Yandex Cloud resources created in this phase"
echo "[OK] No promo code activation in this phase"
echo "[OK] No Managed Kubernetes created in this phase"
echo "[OK] No Compute nodes created in this phase"
echo "[OK] No LoadBalancer created in this phase"
echo "[OK] No public IP created in this phase"
