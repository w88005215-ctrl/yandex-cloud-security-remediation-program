# Toolchain Model

## Purpose

This document defines the local toolchain required for the Yandex Cloud Security Remediation Program.

The toolchain is installed and validated before any paid cloud action.

## Toolchain phases

| Phase | Purpose |
|---|---|
| Phase 4 | Discover current Qubes/AppVM toolchain state |
| Phase 5 | Install base tools in TemplateVM where appropriate |
| Phase 6 | Install project-specific user-space tools where appropriate |
| Phase 7 | Add local CI/security gates |
| Phase 8 | Prepare Terraform skeleton |
| Phase 9 | Prepare local Kubernetes baseline |

## Required tools

| Tool | Purpose | Preferred location |
|---|---|---|
| git | Version control | TemplateVM package |
| curl | Downloads and API calls | TemplateVM package |
| wget | Downloads | TemplateVM package |
| unzip | Archive handling | TemplateVM package |
| jq | JSON processing | TemplateVM package |
| yq | YAML processing | TemplateVM package or user-space binary |
| python3 | Security tools and scripting | TemplateVM package |
| pipx | Python CLI tools | TemplateVM package |
| yc | Yandex Cloud CLI | AppVM user-space or documented install path |
| tofu | OpenTofu IaC | TemplateVM package or AppVM user-space |
| terraform | Terraform IaC, optional if tofu is used | TemplateVM package or AppVM user-space |
| kubectl | Kubernetes CLI | TemplateVM package or AppVM user-space |
| helm | Kubernetes package manager | TemplateVM package or AppVM user-space |
| podman | Container runtime | TemplateVM package |
| docker | Container runtime alternative | TemplateVM package if used |
| kind | Local Kubernetes | AppVM user-space |
| k3d | Local Kubernetes alternative | AppVM user-space |
| trivy | Vulnerability and filesystem scanning | AppVM user-space or CI |
| checkov | IaC scanning | pipx or CI |
| gitleaks | Secret scanning | AppVM user-space or CI |
| semgrep | Static analysis | pipx or CI |
| syft | SBOM generation | AppVM user-space or CI |
| grype | SBOM vulnerability scanning | AppVM user-space or CI |
| kube-score | Kubernetes manifest review | AppVM user-space or CI |
| kubescape | Kubernetes security scanning | AppVM user-space or CI |
| kyverno | Policy-as-code CLI | AppVM user-space or CI |
| cosign | Image signing / verification | AppVM user-space or CI |

## Minimum local toolchain for next phases

Before Terraform and Kubernetes implementation, the minimum useful set is:

- git
- jq
- curl
- unzip
- yc
- tofu or terraform
- kubectl
- gitleaks
- checkov
- trivy

## Installation decision rules

Use TemplateVM when:

- the tool is available from trusted distro repositories;
- the tool is used by several AppVMs;
- the tool belongs to the base operating environment.

Use AppVM user-space installation when:

- the tool is project-specific;
- the tool installs to user home;
- the tool is a standalone binary;
- the tool should not affect other qubes.

## /usr/local rule

Avoid relying on /usr/local for project-specific standalone tools.

Preferred AppVM path:

    ~/.local/bin

This path is persistent in the AppVM home and avoids confusion with TemplateVM inheritance.

## Evidence requirements

After installation or discovery, save:

- tool versions;
- OS information;
- package manager information;
- Git status;
- missing tool list;
- final validation output.

## Publication safety

Toolchain evidence must not contain:

- access tokens;
- cloud profiles with secrets;
- kubeconfig;
- Terraform state;
- billing information.
