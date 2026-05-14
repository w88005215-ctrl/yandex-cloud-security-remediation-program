# Yandex Cloud Security Remediation Program


<!-- YCSEC_PUBLICATION_SUMMARY_START -->
## Portfolio Publication Summary

This repository is an evidence-based cloud security remediation case built on Yandex Cloud.

It demonstrates:

- Terraform-based cloud infrastructure delivery.
- IAM and short-lived credential workflows.
- GitHub Actions OIDC validation without long-lived cloud keys.
- Managed Kubernetes baseline and remediation evidence.
- Kyverno admission policy enforcement.
- Container Registry supply-chain validation.
- SBOM and vulnerability scanning.
- Final remediation metrics, control matrix, risk register, and publication readiness artifacts.
- Conceptual AWS/GCP/Azure control mapping with clear non-claim boundaries.

Core final reports:

- [Final Technical Report EN](docs/final-technical-report-en.md)
- [Final Technical Report RU](docs/final-technical-report-ru.md)
- [Final Remediation Metrics](docs/final-remediation-metrics.md)
- [Final Control Matrix](docs/final-control-matrix.md)
- [Final Risk Register](docs/final-risk-register.md)
- [Cross-Cloud Control Mapping](docs/final-cross-cloud-control-mapping.md)
- [Publication Readiness](docs/final-publication-readiness.md)
- [Retained Bootstrap Cleanup Plan](docs/retained-bootstrap-cleanup-plan.md)

Publication boundary: this repository demonstrates Yandex Cloud implementation evidence and maps AWS/GCP/Azure equivalents conceptually. It does not present live deployment evidence for AWS/GCP/Azure.
<!-- YCSEC_PUBLICATION_SUMMARY_END -->

Terraform + IAM/OIDC/SAML + Managed Kubernetes Hardening + Audit Evidence

## Project purpose

This repository demonstrates a production-like cloud security remediation program on real managed cloud infrastructure using Yandex Cloud.

The project is designed as a portfolio-grade Cloud Security / DevSecOps case. It shows how an insecure cloud and Kubernetes baseline can be identified, remediated, measured and documented with audit-ready evidence.

## Scope

The project covers:

- Terraform / OpenTofu infrastructure as code
- Yandex Cloud IAM and least privilege
- GitHub Actions OIDC / Workload Identity Federation
- SAML/SSO federation pattern
- Yandex Managed Service for Kubernetes
- Kubernetes insecure baseline
- Kubernetes hardening
- RBAC least privilege
- NetworkPolicy
- Pod Security Standards
- Kyverno policy-as-code
- CI/CD security gates
- Trivy, Checkov, Gitleaks, Syft, Grype and related security tooling
- Audit Trails and sanitized evidence
- Before/after remediation metrics
- Risk register
- Control matrix
- AWS/GCP/Azure control mapping
- RU/EN final reports

## Positioning

This is not claimed as AWS, GCP or Azure production experience.

Correct positioning:

Production-like cloud security remediation program on real managed cloud infrastructure with provider-agnostic controls mapped to AWS/GCP/Azure.

## Operating model

The project follows a local-first and short cloud evidence run model:

1. Prepare Terraform, Kubernetes manifests, CI/CD checks and evidence model locally.
2. Run local validation and security scans.
3. Create short-lived Yandex Cloud resources only when evidence collection is ready.
4. Collect evidence.
5. Apply remediation.
6. Measure before/after outcomes.
7. Check cost.
8. Destroy expensive resources.

Managed Kubernetes clusters, compute nodes, public IP addresses and load balancers must not be left running without an active evidence purpose.

## Repository structure

Main areas:

- terraform/ — Terraform modules and environments
- kubernetes/ — insecure baseline, hardened manifests, RBAC, NetworkPolicy, PSS and Kyverno policies
- .github/workflows/ — CI/CD security gates and OIDC-based cloud workflow
- docs/ — architecture, threat model, control matrix, risk register and mapping
- evidence/ — sanitized command outputs, screenshots and before/after metrics
- reports/ — final RU/EN reports
- presentation/ — presentation outline
- scripts/ — helper scripts for evidence, redaction, cost checks and destroy checks

## Evidence-first approach

Each important phase must produce evidence:

- command outputs go to evidence/command-outputs/
- screenshots go to evidence/screenshots/
- baseline findings go to evidence/before/
- remediation results go to evidence/after/
- sanitized audit artifacts go to evidence/sanitized/
- measurable outcomes go to evidence/before-after-metrics.md

## Safety rules

The repository must never contain:

- Terraform state
- kubeconfig files
- service account keys
- IAM tokens
- OIDC tokens
- raw audit logs
- billing data
- unredacted screenshots
- personal or payment data

## Current status

Project phase:

- v0.1-skeleton — repository skeleton initialized
- Phase 2 — root portfolio documentation in progress

## Intended audience

This project is prepared for:

- GitHub portfolio review
- technical interview discussion
- cloud security / DevSecOps demonstration
- academic or training project defense
- security engineering review

<!-- YCSEC:K8S-REMEDIATION-CASE:START -->
## Kubernetes Security Remediation Case

This repository includes a Kubernetes security remediation track that demonstrates a complete evidence-driven workflow:

readiness inventory -> baseline validation -> remediation controls -> before/after comparison -> portfolio case study.

Key documents:

- docs/kubernetes-security-remediation-case-study.md
- docs/kubernetes-baseline-validation-plan.md
- docs/kubernetes-baseline-findings.md
- docs/kubernetes-remediation-results.md
- docs/kubernetes-before-after-remediation-comparison.md

<!-- YCSEC:K8S-REMEDIATION-CASE:END -->

## Final repository audit and publication sanitization

Final public audit artifacts:

- [Final Repository Audit Report EN](docs/final-repository-audit-en.md)
- [Финальный аудит репозитория RU](docs/final-repository-audit-ru.md)
- [Publication Sanitization Report EN](docs/publication-sanitization-report-en.md)
- [Отчёт по публикационной очистке RU](docs/publication-sanitization-report-ru.md)

Publication boundary: repository evidence is sanitized for public portfolio use. It does not contain live cloud credentials, Terraform state, kubeconfig files, PEM keys, or retained cloud runtime artifacts.

## Final Project Completion Report

The project includes final bilingual completion reports summarizing the implemented cloud security remediation workflow, validated evidence domains, sensitive-data/publication-safety status, and claim boundaries:

- [Final Project Completion Report — EN](docs/final-project-completion-report-en.md)
- [Финальный отчёт о завершении проекта — RU](docs/final-project-completion-report-ru.md)

These reports complement the final technical reports, repository audit, sanitization reports, control matrix, risk register, remediation metrics, and evidence index.
