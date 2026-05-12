# Qubes Workstation Model

## Purpose

This project is implemented in Qubes OS using isolated qubes for development, local Kubernetes testing, evidence handling and browser-based cloud access.

The goal is to keep cloud credentials, raw evidence, screenshots and publication artifacts separated.

## Qube model

| Qube | Purpose | Notes |
|---|---|---|
| cloud-dev-workbench | Git, Terraform/OpenTofu, yc CLI, documentation, CI files | Main engineering workspace |
| cloud-k8s-local-lab | kind/k3d, local Kubernetes testing, insecure baseline, hardening tests | Used for local Kubernetes phases |
| cloud-evidence-vault | Raw evidence, screenshots, redaction workflow | Raw evidence should stay here |
| cloud-reporting | Markdown/PDF/report/diagrams preparation | Only sanitized evidence should be imported |
| cloud-browser | GitHub and Yandex Cloud Console | Browser-based actions only |

## dom0 rule

dom0 must not be used for:

- Git development;
- Terraform/OpenTofu;
- yc CLI;
- kubectl;
- Kubernetes testing;
- evidence processing;
- GitHub;
- Yandex Cloud Console.

dom0 is only for Qubes management.

## Installation model

Package-managed tools should be installed in the TemplateVM used by the relevant AppVM.

Examples:

- git
- curl
- wget
- unzip
- jq
- python3
- pipx
- podman

Standalone user-space tools may be installed in the AppVM under:

    ~/.local/bin

This avoids relying on /usr/local behavior and keeps project-specific tooling isolated.

## cloud-dev-workbench tool categories

Required for this project:

| Category | Tools |
|---|---|
| Cloud CLI | yc |
| IaC | tofu or terraform |
| Kubernetes CLI | kubectl, helm |
| Security scanning | gitleaks, checkov, trivy, semgrep |
| Supply chain | syft, grype, cosign |
| Local Kubernetes | kind or k3d |
| Kubernetes security | kube-score, kubescape, kyverno |
| Utilities | git, jq, yq, curl, wget, unzip |

## Evidence rule

Every toolchain change must produce evidence in:

    evidence/command-outputs/

## Security rule

Do not store:

- cloud tokens;
- service account keys;
- kubeconfig files;
- Terraform state;
- raw audit logs;
- billing data.
