# Evidence Index

## Purpose

This document maps project evidence to implemented controls, remediation outcomes and audit artifacts.

The project follows an evidence-first model. Every important phase must produce command output, screenshots, scan reports, before/after findings or sanitized audit logs.

## Evidence storage model

| Evidence Type | Location | Public | Notes |
|---|---|---:|---|
| Command outputs | evidence/command-outputs/ | Yes | Must not contain secrets |
| Screenshots | evidence/screenshots/ | Yes, after review | Must be manually redacted |
| Before-state findings | evidence/before/ | Yes, after review | Used to prove insecure baseline |
| After-state findings | evidence/after/ | Yes, after review | Used to prove remediation |
| Sanitized audit artifacts | evidence/sanitized/ | Yes | Raw logs must not be committed |
| Before/after metrics | evidence/before-after-metrics.md | Yes | Main remediation outcome table |

## Evidence ID convention

| Prefix | Area |
|---|---|
| EVID-LOCAL | Local workstation and repository setup |
| EVID-COST | Cost control and budget discipline |
| EVID-PUB | Publication safety |
| EVID-IAC | Terraform / IaC |
| EVID-IAM | IAM and least privilege |
| EVID-OIDC | GitHub Actions OIDC / Workload Identity Federation |
| EVID-SAML | SAML/SSO federation pattern |
| EVID-K8S | Kubernetes baseline and hardening |
| EVID-NET | NetworkPolicy and network isolation |
| EVID-IMG | Image scanning, SBOM and vulnerabilities |
| EVID-AUD | Audit Trails and audit evidence |
| EVID-CTRL | Control matrix and governance |

## Current evidence inventory

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-LOCAL-001 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_repository_skeleton_control.txt | Repository skeleton validation | Yes | Yes |
| EVID-LOCAL-002 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_first_commit_precheck.txt | First commit precheck | Yes | Yes |
| EVID-LOCAL-003 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_first_commit_result.txt | First commit result | Yes | Yes |
| EVID-DOC-001 | Phase 2 | evidence/command-outputs/YCSEC_02_OUTPUT_root_portfolio_files_control.txt | Root portfolio documentation control | Yes | Yes |
| EVID-DOC-002 | Phase 2 | evidence/command-outputs/YCSEC_02_OUTPUT_final_git_control.txt | Phase 2 final git control | Yes | Yes |
| EVID-COST-001 | Phase 3 | docs/cost-control.md | Cost-control model | Yes | Yes |
| EVID-COST-002 | Phase 3 | docs/resource-inventory.md | Resource inventory model | Yes | Yes |
| EVID-PUB-001 | Phase 3 | docs/publication-safety-checklist.md | Publication safety checklist | Yes | Yes |
| EVID-LOCAL-004 | Phase 3 | evidence/command-outputs/YCSEC_03_OUTPUT_tool_versions.txt | Local tool version inventory | Yes | Yes |

## Evidence quality rules

Evidence must answer:

- what was executed;
- where it was executed;
- when it was executed;
- what changed;
- what control it supports;
- whether it is safe to publish.

## Redaction rules

Before public release, redact or remove:

- tokens;
- keys;
- service account credentials;
- kubeconfig content;
- Terraform state;
- raw audit logs;
- billing data;
- personal data;
- payment data;
- sensitive account identifiers where not required.

## Reviewer note

Evidence in this project is intentionally structured so a reviewer can trace the path:

architecture -> implementation -> scan result -> remediation -> audit evidence -> control matrix -> final report.

## Phase 4 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-LOCAL-005 | Phase 4 | docs/qubes-workstation-model.md | Qubes workstation isolation model | Yes | Yes |
| EVID-LOCAL-006 | Phase 4 | docs/toolchain-model.md | Toolchain installation and validation model | Yes | Yes |
| EVID-LOCAL-007 | Phase 4 | evidence/command-outputs/YCSEC_04_OUTPUT_qubes_toolchain_discovery.txt | Qubes/AppVM environment discovery | Yes | Yes |
| EVID-LOCAL-008 | Phase 4 | evidence/command-outputs/YCSEC_04_OUTPUT_toolchain_check.txt | Current local toolchain status | Yes | Yes |


## Phase 5 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-LOCAL-013 | Phase 5 | evidence/command-outputs/YCSEC_05_OUTPUT_clean_toolchain_check.txt | Clean final local toolchain validation | Yes | Yes |
| EVID-LOCAL-014 | Phase 5 | evidence/command-outputs/YCSEC_05_OUTPUT_clean_toolchain_control.txt | Final clean toolchain control evidence | Yes | Yes |
| EVID-LOCAL-015 | Phase 5 | evidence/command-outputs/YCSEC_05_OUTPUT_final_git_control.txt | Git commit and tag evidence for toolchain baseline | Yes | Yes |


## Phase 6 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-IAC-001 | Phase 6 | evidence/command-outputs/YCSEC_06_OUTPUT_local_security_gates.txt | Clean local Terraform/OpenTofu and security gate output | Yes | Yes |
| EVID-IAC-002 | Phase 6 | evidence/command-outputs/YCSEC_06_OUTPUT_iac_skeleton_control.txt | IaC skeleton final control evidence | Yes | Yes |
| EVID-IAC-003 | Phase 6 | evidence/command-outputs/YCSEC_06_OUTPUT_final_git_control.txt | Git commit and tag evidence for IaC skeleton | Yes | Yes |

## Phase 7 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-CTRL-001 | Phase 7 | docs/control-matrix.md | Security control matrix | Yes | Yes |
| EVID-CTRL-002 | Phase 7 | docs/risk-register.md | Risk register | Yes | Yes |
| EVID-CTRL-003 | Phase 7 | docs/ru/threat-model.md | RU threat model | Yes | Yes |
| EVID-CTRL-004 | Phase 7 | docs/en/threat-model.md | EN threat model | Yes | Yes |
| EVID-CTRL-005 | Phase 7 | docs/ru/iam-oidc-saml-design.md | RU IAM/OIDC/SAML design | Yes | Yes |
| EVID-CTRL-006 | Phase 7 | docs/en/iam-oidc-saml-design.md | EN IAM/OIDC/SAML design | Yes | Yes |
| EVID-CTRL-007 | Phase 7 | diagrams/ycsec-iam-oidc-saml-flow.mmd | IAM/OIDC/SAML flow diagram | Yes | Yes |
| EVID-CTRL-008 | Phase 7 | diagrams/ycsec-evidence-flow.mmd | Evidence flow diagram | Yes | Yes |
| EVID-CTRL-009 | Phase 7 | evidence/command-outputs/YCSEC_07_OUTPUT_control_model_validation.txt | Phase 7 control evidence | Yes | Yes |
| EVID-CTRL-010 | Phase 7 | evidence/command-outputs/YCSEC_07_OUTPUT_final_git_control.txt | Phase 7 git evidence | Yes | Yes |


## Phase 8 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-K8S-001 | Phase 8 | evidence/command-outputs/YCSEC_08_OUTPUT_kubernetes_static_validation.txt | Kubernetes static manifest validation output | Yes | Yes |
| EVID-K8S-002 | Phase 8 | evidence/command-outputs/YCSEC_08_OUTPUT_kubernetes_validation.txt | Final Kubernetes static baseline control evidence | Yes | Yes |
| EVID-K8S-003 | Phase 8 | evidence/command-outputs/YCSEC_08_OUTPUT_final_git_control.txt | Git commit and tag evidence for Kubernetes static baseline | Yes | Yes |
