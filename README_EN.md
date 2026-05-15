# Yandex Cloud Security Remediation Program

Terraform + IAM/OIDC + Managed Kubernetes Hardening + Audit Evidence

## Project status

**Status:** completed portfolio-grade cloud security remediation case.

This repository demonstrates an evidence-driven cloud security remediation program implemented on real managed cloud infrastructure. The project covers the complete workflow from insecure baseline identification to remediation as code, policy enforcement, supply-chain validation, cleanup evidence, public sanitization, and final reporting.

Final state:

- Final RU/EN technical reports completed.
- Final bilingual PDF report placed in the repository root beside `README.md`.
- Cloud evidence collection completed.
- Managed Kubernetes baseline/remediation evidence completed.
- GitHub Actions OIDC validation completed without long-lived cloud keys.
- Supply-chain validation, SBOM, vulnerability metrics, Kyverno policy enforcement, Checkov and Gitleaks gates completed.
- Retained bootstrap resources cleaned up after evidence validation.
- Public repository audit, sanitization and publication artifact curation completed.
- Final remediation metrics, control matrix, risk register and cross-cloud mapping published.

## Final PDF report

- [Final PDF Report — RU/EN](yandex_cloud_security_remediation_final_report_ru_en.pdf)
- [PDF report index](docs/final-pdf-report.md)

## Core final reports

- [Final Technical Report EN](docs/final-technical-report-en.md)
- [Final Technical Report RU](docs/final-technical-report-ru.md)
- [Final Project Completion Report EN](docs/final-project-completion-report-en.md)
- [Final Project Completion Report RU](docs/final-project-completion-report-ru.md)
- [Final Remediation Metrics](docs/final-remediation-metrics.md)
- [Final Control Matrix](docs/final-control-matrix.md)
- [Final Risk Register](docs/final-risk-register.md)
- [Cross-Cloud Control Mapping](docs/final-cross-cloud-control-mapping.md)
- [Publication Readiness](docs/final-publication-readiness.md)
- [Final Repository Audit EN](docs/final-repository-audit-en.md)
- [Publication Sanitization Report EN](docs/publication-sanitization-report-en.md)
- [Evidence Index](docs/evidence-index.md)

## What the project demonstrates

- Terraform / OpenTofu infrastructure as code.
- Yandex Cloud IAM and least-privilege service accounts.
- GitHub Actions OIDC / Workload Identity Federation without long-lived cloud keys.
- SAML/SSO federation pattern.
- Yandex Managed Service for Kubernetes.
- Kubernetes insecure baseline and hardened remediation state.
- RBAC least privilege, NetworkPolicy and Pod Security Standards.
- Kyverno policy-as-code admission control.
- CI/CD security gates.
- Container Registry workflow validation.
- SBOM generation with CycloneDX.
- Vulnerability evidence using Trivy and Grype.
- IaC validation with Checkov.
- Secret scanning with Gitleaks.
- Audit Trails evidence and cleanup evidence.
- Before/after remediation metrics.
- Final control matrix and risk register.
- Conceptual AWS/GCP/Azure control mapping.

## Correct positioning

This repository demonstrates practical cloud security engineering on Yandex Cloud and maps equivalent controls conceptually to AWS, GCP and Azure.

It must not be represented as:

- AWS/GCP/Azure production experience.
- Continuous production operation of live cloud infrastructure.
- Ownership of third-party production infrastructure.
- A repository containing live cloud credentials, Terraform state, kubeconfig files, PEM keys or retained cloud runtime artifacts.

Correct positioning:

> Production-like cloud security remediation program on real managed cloud infrastructure with provider-agnostic controls mapped conceptually to AWS/GCP/Azure.

## Repository structure

Main areas:

- `terraform/` — Terraform environments and infrastructure definitions.
- `kubernetes/` — insecure baseline, hardened manifests, RBAC, NetworkPolicy, PSS and Kyverno policies.
- `.github/workflows/` — CI/CD security gates and OIDC-based validation workflows.
- `docs/` — architecture, final reports, control matrix, risk register, mapping, publication readiness and audit reports.
- `evidence/` — curated sanitized evidence, metrics and validation outputs.
- `scripts/` — helper scripts for validation, evidence collection, redaction, cost checks and cleanup checks.
- `presentation/` — presentation outline.
- `yandex_cloud_security_remediation_final_report_ru_en.pdf` — final bilingual PDF report in the repository root.

## Evidence model

The project follows an evidence-first model:

- command outputs are stored under `evidence/command-outputs/`;
- baseline findings are stored under `evidence/before/`;
- remediation evidence is stored under `evidence/after/`;
- sanitized audit artifacts are stored under `evidence/sanitized/`;
- final metrics are stored under `evidence/metrics/`;
- final reports and governance documents are stored under `docs/`.

The public tree was curated to remove low-value intermediate execution noise while preserving final reports, final metrics, validated security evidence, audit reports, sanitization records and publication boundary documentation.

## Security and publication safety

The repository has been checked for:

- Terraform state files;
- kubeconfig files;
- service account keys;
- IAM/OIDC tokens;
- PEM/private key material;
- raw audit logs;
- billing data;
- unredacted sensitive evidence;
- personal or payment data.

Final validation included Gitleaks, Checkov, repository safety checks, public artifact curation and final publication consistency cleanup.

## Intended audience

This project is prepared for:

- GitHub portfolio review;
- technical interview discussion;
- cloud security / DevSecOps demonstration;
- academic or training project defense;
- security engineering review.

