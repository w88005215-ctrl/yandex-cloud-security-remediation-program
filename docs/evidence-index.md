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

## Phase 9 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-K8S-004 | Phase 9 | evidence/command-outputs/YCSEC_09_OUTPUT_local_kubernetes_runtime_validation.txt | Local kind-based Kubernetes runtime validation | Yes | Yes |
| EVID-K8S-005 | Phase 9 | evidence/command-outputs/YCSEC_09_OUTPUT_runtime_validation_control.txt | Final Phase 9 runtime validation control evidence | Yes | Yes |
| EVID-K8S-006 | Phase 9 | evidence/command-outputs/YCSEC_09_OUTPUT_final_git_control.txt | Git commit and tag evidence for local Kubernetes runtime validation | Yes | Yes |

## Phase 10 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-YC-001 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_yandex_cloud_readiness.txt | Read-only Yandex Cloud readiness gate output | Yes | Yes |
| EVID-YC-002 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_control.txt | Final Phase 10 control evidence | Yes | Yes |
| EVID-YC-003 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_git_control.txt | Git tag evidence for Yandex Cloud readiness gate | Yes | Yes |

## Phase 10 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-YC-001 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_yandex_cloud_readiness.txt | Read-only Yandex Cloud readiness gate output | Yes | Yes |
| EVID-YC-002 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_control.txt | Final Phase 10 control evidence | Yes | Yes |
| EVID-YC-003 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_git_control.txt | Git tag evidence for Yandex Cloud readiness gate | Yes | Yes |

## Phase 10 evidence

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-YC-001 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_yandex_cloud_readiness.txt | Read-only Yandex Cloud readiness gate output | Yes | Yes |
| EVID-YC-002 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_control.txt | Final Phase 10 control evidence | Yes | Yes |
| EVID-YC-003 | Phase 10 | evidence/command-outputs/YCSEC_10_OUTPUT_final_git_control.txt | Git tag evidence for Yandex Cloud readiness gate | Yes | Yes |

<!-- YCSEC:PHASE-11-SMOKE-RUN:START -->
## Phase 11.2 — Yandex Cloud Managed Kubernetes Smoke-Run

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-YC-SMOKE-001 | evidence/command-outputs/YCSEC_11_2_OUTPUT_hardened_smoke_run_success_sanitized.txt | Command output | Sanitized successful Yandex Cloud Managed Kubernetes smoke-run output | Public-safe |
| EVID-YC-SMOKE-002 | evidence/command-outputs/YCSEC_11_2_OUTPUT_smoke_run_success_closeout.txt | Closeout control | Final smoke-run closeout with zero-resource verification | Public-safe |
| EVID-YC-SMOKE-003 | docs/cloud-smoke-run-validation.md | Technical summary | Project-level validation summary for the successful smoke-run | Public-safe |

Validation summary:

- Terraform provider authentication passed through runtime Yandex Cloud values.
- Terraform plan created the expected temporary cloud infrastructure.
- Terraform apply created real Yandex Cloud Managed Kubernetes resources.
- kubectl confirmed Kubernetes API access and worker node readiness.
- Gitleaks completed with no leaks detected.
- Terraform destroy removed all temporary resources.
- Post-destroy inventory checks confirmed zero remaining smoke resources.
- Sanitized evidence was committed for portfolio publication.

<!-- YCSEC:PHASE-11-SMOKE-RUN:END -->

<!-- YCSEC:PHASE-12-1-BASELINE-PLAN:START -->
## Phase 12.1 — Kubernetes Baseline Validation Plan

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-K8S-PLAN-001 | docs/kubernetes-baseline-validation-plan.md | Technical plan | Kubernetes baseline validation and remediation plan | Public-safe |
| EVID-K8S-PLAN-002 | docs/kubernetes-baseline-control-matrix.md | Control matrix | Baseline control mapping, remediation direction and evidence expectations | Public-safe |
| EVID-K8S-PLAN-003 | evidence/command-outputs/YCSEC_12_1_OUTPUT_kubernetes_baseline_validation_plan.txt | Command output | Phase 12.1 plan generation and validation evidence | Public-safe |

Phase result:

- Baseline validation scope defined.
- Kubernetes control areas mapped.
- Expected findings defined.
- Remediation directions defined.
- Evidence model defined for baseline and remediation phases.
- Portfolio-facing remediation narrative prepared.

<!-- YCSEC:PHASE-12-1-BASELINE-PLAN:END -->

<!-- YCSEC:PHASE-12-2-BASELINE-VALIDATION:START -->
## Phase 12.2 — Kubernetes Baseline Static Validation

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-K8S-BASE-001 | evidence/command-outputs/YCSEC_12_2_OUTPUT_kubernetes_baseline_static_validation.txt | Command output | Local Kubernetes baseline static validation output | Public-safe |
| EVID-K8S-BASE-002 | docs/kubernetes-baseline-findings.md | Findings summary | Baseline findings and remediation direction | Public-safe |
| EVID-K8S-BASE-003 | scripts/validate-kubernetes-baseline-static.sh | Validation script | Reusable local static validator for Kubernetes baseline controls | Public-safe |

Phase result:

- Kubernetes baseline manifests were inspected locally.
- Baseline control coverage was measured.
- Findings were converted into remediation targets.
- Before-state metrics were recorded.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-2-BASELINE-VALIDATION:END -->

<!-- YCSEC:PHASE-12-3-REMEDIATION:START -->
## Phase 12.3 — Kubernetes Remediation Control Package

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-K8S-REM-001 | evidence/command-outputs/YCSEC_12_3_OUTPUT_kubernetes_remediation_control_package.txt | Command output | Remediation package generation and static validation output | Public-safe |
| EVID-K8S-REM-002 | docs/kubernetes-remediation-results.md | Remediation summary | Kubernetes remediation control package results | Public-safe |
| EVID-K8S-REM-003 | scripts/validate-kubernetes-remediation-static.sh | Validation script | Reusable remediation static validator | Public-safe |
| EVID-K8S-REM-004 | kubernetes/remediation | Kubernetes manifests | Remediated namespace, RBAC, NetworkPolicy, workload and Service manifests | Public-safe |
| EVID-K8S-REM-005 | policies/kyverno/kubernetes-baseline-controls.yaml | Policy-as-code | Kyverno policy package for baseline control validation | Public-safe |

Phase result:

- Remediation Kubernetes manifest package was created.
- Runtime hardening controls were implemented.
- Network segmentation controls were implemented.
- Least-privilege RBAC controls were implemented.
- Policy-as-code guardrails were added.
- Local remediation static validation passed.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-3-REMEDIATION:END -->

<!-- YCSEC:PHASE-12-4-COMPARISON:START -->
## Phase 12.4 — Kubernetes Before/After Remediation Comparison

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-K8S-COMP-001 | evidence/command-outputs/YCSEC_12_4_OUTPUT_kubernetes_before_after_comparison.txt | Command output | Local before/after remediation comparison output | Public-safe |
| EVID-K8S-COMP-002 | docs/kubernetes-before-after-remediation-comparison.md | Comparison summary | Portfolio-ready baseline/remediation improvement summary | Public-safe |
| EVID-K8S-COMP-003 | scripts/compare-kubernetes-baseline-remediation.sh | Comparison script | Reusable local comparison script | Public-safe |

Phase result:

- Baseline and remediation posture were compared locally.
- Before/after metrics were recorded.
- Remediation regression checks passed.
- Portfolio-ready remediation outcome was documented.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-4-COMPARISON:END -->

<!-- YCSEC:PHASE-12-5-CASE-STUDY:START -->
## Phase 12.5 — Kubernetes Remediation Case Study

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-K8S-CASE-001 | docs/kubernetes-security-remediation-case-study.md | Case study | Portfolio-ready Kubernetes remediation case study | Public-safe |
| EVID-K8S-CASE-002 | evidence/command-outputs/YCSEC_12_5_OUTPUT_kubernetes_remediation_case_study.txt | Command output | Case study generation and validation evidence | Public-safe |

Phase result:

- Kubernetes remediation track was packaged as a portfolio-ready case study.
- Engineering workflow was documented from readiness to before/after comparison.
- Security outcomes were summarized.
- Evidence references were consolidated.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-5-CASE-STUDY:END -->

<!-- YCSEC:PHASE-12-6-ROADMAP-RECONCILIATION:START -->
## Phase 12.6 — Roadmap Reconciliation and Cloud Evidence Gap Register

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-ROADMAP-001 | docs/roadmap-reconciliation.md | Roadmap reconciliation | Reconciles current repository state with the intended roadmap | Public-safe |
| EVID-ROADMAP-002 | docs/cloud-evidence-gap-register.md | Gap register | Tracks remaining cloud evidence gaps | Public-safe |
| EVID-ROADMAP-003 | docs/portfolio-claims-policy.md | Claims policy | Defines allowed and blocked portfolio claims at current maturity | Public-safe |
| EVID-ROADMAP-004 | evidence/command-outputs/YCSEC_12_6_OUTPUT_roadmap_reconciliation.txt | Command output | Phase 12.6 generation and validation evidence | Public-safe |

Phase result:

- Current project state was reconciled with the original roadmap.
- Completed evidence and missing evidence were separated.
- Premature final-release claims were blocked.
- Next cloud evidence sequence was defined.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-6-ROADMAP-RECONCILIATION:END -->

