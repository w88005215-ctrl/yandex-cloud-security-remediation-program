# Toolchain Installation Model

This project uses a Qubes-aware local toolchain model.

## Scope

This phase prepares the local engineering workstation for:

- Terraform and OpenTofu development;
- Yandex Cloud CLI operations;
- Kubernetes local and cloud validation;
- IaC security scanning;
- secret scanning;
- container image scanning;
- SBOM generation;
- Kubernetes hardening validation;
- policy-as-code checks;
- GitHub repository quality gates.

## Qubes OS model

Development commands are executed in:

- cloud-dev-workbench.

Package installation that should persist across AppVM rebuilds is performed in the related TemplateVM.

Project-specific credentials, kubeconfig files, Terraform state files, cloud tokens and service account keys must never be stored in TemplateVM.

## Trusted installation model

The preferred installation paths are:

- Fedora packages through dnf in TemplateVM;
- project-neutral user tools in HOME/.local/bin where appropriate;
- Python security tools through pipx;
- Node-based quality tools through npm user prefix.

For gitleaks, the accepted local baseline is the Fedora package installed in TemplateVM and resolved in the AppVM as /usr/bin/gitleaks.

## Required tool groups

Cloud and IaC:

- yc;
- terraform;
- tofu.

Kubernetes:

- kubectl;
- helm;
- yq.

Local container and Kubernetes tooling:

- podman;
- buildah;
- skopeo;
- kind;
- k3d.

Security tooling:

- gitleaks;
- trivy;
- checkov;
- semgrep;
- syft;
- grype;
- kube-score;
- kubescape;
- kyverno;
- cosign.

Repository quality tooling:

- gh;
- shellcheck;
- yamllint;
- markdownlint;
- pre-commit.

## Publication rule

The repository must not publish:

- raw installer logs with failed downloader attempts;
- service account keys;
- tokens;
- kubeconfig files;
- Terraform state;
- billing data;
- raw audit logs;
- screenshots with personal or account data.

Only clean final toolchain evidence is kept in the public evidence package.
