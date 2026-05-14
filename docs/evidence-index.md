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

<!-- YCSEC:PHASE-12-7-BOOTSTRAP-OIDC-AUDIT-PLAN:START -->
## Phase 12.7 — Bootstrap/OIDC/Audit Cloud-Run Plan

| Evidence ID | File | Type | Description | Publication Status |
|---|---|---|---|---|
| EVID-BOOTPLAN-001 | docs/bootstrap-oidc-audit-cloud-run-plan.md | Cloud-run plan | Controlled bootstrap/OIDC/audit cloud-run plan | Public-safe |
| EVID-BOOTPLAN-002 | docs/iam-oidc-audit-control-design.md | Control design | IAM, OIDC/WIF and audit control design | Public-safe |
| EVID-BOOTPLAN-003 | docs/bootstrap-cloud-run-checklist.md | Checklist | Pre-run, during-run and post-run checklist | Public-safe |
| EVID-BOOTPLAN-004 | docs/bootstrap-evidence-collection-plan.md | Evidence plan | Bootstrap evidence collection and redaction plan | Public-safe |
| EVID-BOOTPLAN-005 | evidence/command-outputs/YCSEC_12_7_OUTPUT_bootstrap_oidc_audit_cloud_run_plan.txt | Command output | Phase 12.7 generation and validation evidence | Public-safe |

Phase result:

- Bootstrap/OIDC/Audit cloud-run was planned.
- IAM/OIDC/Audit control design was defined.
- Bootstrap cloud-run checklist was created.
- Evidence collection and redaction plan was created.
- No cloud resources were created.

<!-- YCSEC:PHASE-12-7-BOOTSTRAP-OIDC-AUDIT-PLAN:END -->

<!-- YCSEC-12.8A-BOOTSTRAP-IMPLEMENTATION -->

## YCSEC-12.8A — Bootstrap/OIDC/Audit Implementation Package

| Evidence ID | Artifact | Purpose | Status |
|---|---|---|---|
| YCSEC-12.8A-001 | `terraform/environments/bootstrap-oidc-audit/` | Terraform implementation for IAM/OIDC, registry, Object Storage and Audit Trails bootstrap | Prepared |
| YCSEC-12.8A-002 | `scripts/run-bootstrap-oidc-audit-cloud-run.sh` | Controlled cloud-run script with explicit approval, temporary runtime and cleanup logic | Prepared |
| YCSEC-12.8A-003 | `.github/workflows/cloud-deploy-oidc.yml` | GitHub Actions OIDC token smoke workflow template | Prepared |
| YCSEC-12.8A-004 | `docs/bootstrap-cloud-run-implementation.md` | Operator-facing implementation scope and evidence policy | Prepared |
| YCSEC-12.8A-005 | `evidence/command-outputs/YCSEC_12_8A_OUTPUT_bootstrap_cloud_run_implementation_package.txt` | Command evidence for local implementation package creation | Pending commit |

## EVID-YC-BOOTSTRAP-REPAIR-001 — Bootstrap/OIDC/Audit provisioning repair

Evidence:
- `evidence/command-outputs/YCSEC_12_8B_OUTPUT_bootstrap_repair_apply_sanitized.txt`
- `docs/bootstrap-oidc-audit-cloud-run-results.md`

Result:
- Bootstrap identity, registry, Object Storage, and Audit Trails resources were provisioned.
- Bucket-name generation was corrected to use lowercase timestamps.
- Terraform runtime and state remained outside the public repository.
- Bootstrap resources were retained temporarily for OIDC, Audit Trails, and registry validation.

## EVID-OIDC-12-8D — GitHub Actions OIDC validation

- Phase: 12.8D
- Status: implemented
- Evidence:
  - `evidence/command-outputs/YCSEC_12_8D_OUTPUT_github_actions_oidc_validation_success.txt`
  - `.github/workflows/cloud-deploy-oidc.yml`
  - `docs/github-actions-oidc-validation.md`
- Control value: GitHub Actions authenticates to Yandex Cloud through OIDC token exchange without long-lived cloud key material.

## Phase 12.8E — Audit Trails delivery validation

| Evidence | Description |
|---|---|
| `docs/audit-trails-evidence-validation.md` | Audit Trails delivery validation result |
| `evidence/sanitized/audit_trails_delivery_object_listing_redacted.txt` | Sanitized Object Storage delivery evidence |
| `evidence/command-outputs/YCSEC_12_8E_OUTPUT_audit_trails_delivery_validation.txt` | Command evidence for Audit Trails delivery validation |

## Phase 12.8F — Registry and evidence storage validation

| Evidence | Description |
|---|---|
| `docs/registry-evidence-storage-validation.md` | Registry and evidence storage validation result |
| `evidence/command-outputs/YCSEC_12_8F_OUTPUT_registry_evidence_storage_validation.txt` | Command evidence for retained registry and evidence storage validation |

## Phase 12.9 — Managed Kubernetes baseline/remediation cloud-run plan

| Evidence | Description |
|---|---|
| docs/managed-kubernetes-cloud-run-plan.md | Managed Kubernetes baseline/remediation cloud-run plan |
| docs/managed-kubernetes-cloud-run-checklist.md | Execution checklist for the next controlled cloud-run |
| docs/managed-kubernetes-evidence-collection-plan.md | Evidence collection plan for before/after Kubernetes cloud validation |
| docs/managed-kubernetes-vulnerability-demonstration-plan.md | Controlled vulnerability demonstration plan |
| docs/managed-kubernetes-destroy-and-retention-plan.md | Destroy and retention policy for Kubernetes cloud-run resources |
| evidence/command-outputs/YCSEC_12_9_OUTPUT_managed_kubernetes_cloud_run_plan.txt | Command evidence for Phase 12.9 |
| evidence/command-outputs/YCSEC_12_9_OUTPUT_final_git_control.txt | Final git control evidence for Phase 12.9 |

## Phase 13.0A — Managed Kubernetes cloud-run implementation package

Evidence:

- docs/managed-kubernetes-cloud-run-implementation.md — implementation package description.
- docs/managed-kubernetes-cloud-run-operator-runbook.md — operator runbook for the real cloud-run.
- terraform/environments/managed-kubernetes-cloud-run — Terraform package for short-lived Managed Kubernetes resources.
- scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh — controlled cloud-run script.
- scripts/validate-managed-kubernetes-cloud-run-package.sh — static implementation package validator.
- kubernetes/cloud-run/insecure-baseline — controlled insecure baseline manifests.
- kubernetes/cloud-run/hardened — hardened remediation manifests.
- policies/kyverno/cloud-run — policy-as-code controls.
- evidence/command-outputs/YCSEC_13_0A_OUTPUT_managed_kubernetes_cloud_run_implementation_package.txt — command evidence for this phase.
- evidence/command-outputs/YCSEC_13_0A_OUTPUT_final_git_control.txt — final git control evidence.

Cloud resources created in this phase: none.

## Phase 13.0 — Managed Kubernetes baseline/remediation cloud-run

| Evidence | Description |
|---|---|
| `docs/managed-kubernetes-cloud-run-results.md` | Results of the real Managed Kubernetes baseline/remediation cloud-run |
| `docs/managed-kubernetes-before-after-cloud-comparison.md` | Before/after cloud comparison for Kubernetes remediation |
| `evidence/before/` | Insecure baseline deployment and scanner evidence |
| `evidence/after/` | Hardened/remediated deployment and validation evidence |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_managed_kubernetes_baseline_remediation_cloud_run.txt` | Main command evidence for Phase 13.0 |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_apply_sanitized.txt` | Sanitized Terraform apply evidence |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_destroy_sanitized.txt` | Sanitized Terraform destroy evidence |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_mks_cluster_list.txt` | Post-destroy Managed Kubernetes inventory |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_compute_instance_list.txt` | Post-destroy Compute inventory |
| `evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_nlb_list.txt` | Post-destroy Network Load Balancer inventory |

## Phase 13.1 — Supply Chain Security roadmap extension

| Evidence | Description |
|---|---|
| `docs/supply-chain-security-roadmap-extension.md` | Roadmap extension for CI/OIDC, registry, SBOM, vulnerability scanning, and admission policy enforcement |
| `docs/container-image-vulnerability-cloud-run-plan.md` | Container image vulnerability and hardening evidence plan |
| `docs/ci-oidc-registry-build-push-plan.md` | GitHub Actions OIDC to Yandex Container Registry build/push plan |
| `docs/kyverno-admission-policy-enforcement-plan.md` | Kubernetes admission policy enforcement plan |
| `docs/supply-chain-evidence-and-metrics-plan.md` | Evidence and metrics plan for supply-chain validation |
| `evidence/command-outputs/YCSEC_13_1_OUTPUT_supply_chain_roadmap_extension.txt` | Command evidence for Phase 13.1 |
| `evidence/command-outputs/YCSEC_13_1_OUTPUT_final_git_control.txt` | Final git control evidence for Phase 13.1 |

## Phase 13.2 — Supply Chain implementation package

| Evidence | Description |
|---|---|
| `docs/supply-chain-implementation-package.md` | Supply-chain implementation package summary |
| `docs/supply-chain-operator-runbook.md` | Operator runbook for upcoming registry/SBOM/admission phases |
| `supply-chain/demo-app/` | Controlled vulnerable/remediated demo workload |
| `.github/workflows/supply-chain-oidc-registry-validation.yml` | GitHub OIDC registry build/push validation workflow |
| `scripts/run-supply-chain-local-evidence.sh` | Local SBOM/vulnerability evidence helper |
| `scripts/validate-supply-chain-package.sh` | Supply-chain package validator |
| `policies/kyverno/supply-chain/registry-and-image-policy.yaml` | Admission policy package for registry/image controls |
| `evidence/command-outputs/YCSEC_13_2_OUTPUT_supply_chain_implementation_package.txt` | Phase 13.2 command evidence |
| `evidence/command-outputs/YCSEC_13_2_OUTPUT_final_git_control.txt` | Phase 13.2 final git control evidence |

## Phase 13.3 — Supply Chain OIDC Registry validation

| Evidence | Description |
|---|---|
| `docs/supply-chain-oidc-registry-validation.md` | Supply-chain OIDC registry validation result |
| `evidence/command-outputs/YCSEC_13_3_OUTPUT_failed_build_log_analysis.txt` | Sanitized analysis of the failed build/push attempt |
| `evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation.txt` | Command evidence for Phase 13.3 |
| `evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation_success.txt` | Sanitized GitHub Actions OIDC registry push evidence |
| `evidence/command-outputs/YCSEC_13_3_OUTPUT_registry_inventory_after_push.txt` | Sanitized registry inventory after image push |

## Phase 13.4 — SBOM and vulnerability validation

| Evidence | Description |
|---|---|
| `docs/sbom-vulnerability-validation.md` | SBOM and vulnerability validation result document |
| `docs/supply-chain-vulnerability-metrics.md` | Before/after supply-chain vulnerability metrics summary |
| `evidence/sbom/ycsec_supply_chain_insecure_sbom_cyclonedx.json` | Insecure image SBOM |
| `evidence/sbom/ycsec_supply_chain_hardened_sbom_cyclonedx.json` | Hardened image SBOM |
| `evidence/vulnerability/trivy_insecure_image.json` | Trivy insecure image scan |
| `evidence/vulnerability/trivy_hardened_image.json` | Trivy hardened image scan |
| `evidence/vulnerability/grype_insecure_image.json` | Grype insecure image scan |
| `evidence/vulnerability/grype_hardened_image.json` | Grype hardened image scan |
| `evidence/metrics/supply_chain_vulnerability_metrics.json` | Machine-readable vulnerability metrics |
| `evidence/command-outputs/YCSEC_13_4_OUTPUT_sbom_vulnerability_validation.txt` | Phase 13.4 command evidence |

## Phase 13.4A — gitleaks generated evidence handling

| Evidence | Description |
|---|---|
| `.gitleaks.toml` | Strict generated-evidence allowlist while extending default gitleaks rules |
| `docs/generated-evidence-gitleaks-handling.md` | Rationale and security boundary for generated scanner evidence handling |
| `evidence/command-outputs/YCSEC_13_4A_OUTPUT_gitleaks_generated_evidence_handling.txt` | Command evidence for Phase 13.4A |
| `evidence/command-outputs/YCSEC_13_4A_OUTPUT_gitleaks_findings_sanitized.txt` | Sanitized finding classification without secret/match values |
| `evidence/command-outputs/YCSEC_13_4A_OUTPUT_final_git_control.txt` | Final git control evidence |

## Phase 13.5A — Kyverno MKS repair package

| Evidence | Description |
|---|---|
| `scripts/run-kyverno-admission-policy-mks-validation.sh` | Corrected controlled Kyverno admission validation runner |
| `kubernetes/admission-validation/` | Public admission validation manifests |
| `docs/kyverno-admission-policy-enforcement-validation.md` | Kyverno admission validation documentation |
| `docs/kyverno-admission-policy-enforcement-metrics.md` | Planned admission enforcement metrics |
| `evidence/command-outputs/YCSEC_13_5A_OUTPUT_kyverno_mks_repair_package.txt` | Command evidence for local repair package |
| `evidence/command-outputs/YCSEC_13_5A_OUTPUT_final_git_control.txt` | Final git control evidence |

## Phase 13.5A1 — Kyverno denial attribution fix

| Evidence | Description |
|---|---|
| `kubernetes/admission-validation/namespace.yaml` | Admission validation namespace without Pod Security enforce label |
| `scripts/run-kyverno-admission-policy-mks-validation.sh` | Corrected denial validation requiring Kyverno-specific evidence |
| `evidence/command-outputs/YCSEC_13_5A1_OUTPUT_kyverno_denial_attribution_fix.txt` | Command evidence for attribution fix |
| `evidence/command-outputs/YCSEC_13_5A1_OUTPUT_final_git_control.txt` | Final git control evidence |

## Phase 13.5A2 — Kyverno MKS runner hardening

| Evidence | Description |
|---|---|
| `scripts/run-kyverno-admission-policy-mks-validation.sh` | Hardened Kyverno Managed Kubernetes validation runner |
| `evidence/command-outputs/YCSEC_13_5A2_OUTPUT_kyverno_runner_hardening.txt` | Command evidence for local runner hardening |
| `evidence/command-outputs/YCSEC_13_5A2_OUTPUT_final_git_control.txt` | Final git control evidence for runner hardening |

<!-- phase-13-5-kyverno-admission:start -->
## Phase 13.5 — Kyverno admission policy enforcement validation

Status: completed.

Public evidence:

- `docs/kyverno-admission-policy-enforcement-validation.md`
- `docs/kyverno-admission-policy-enforcement-metrics.md`
- `evidence/after/kyverno_mks_nodes_ready.txt`
- `evidence/after/kyverno_install_apply.txt`
- `evidence/after/kyverno_controller_pods_ready.txt`
- `evidence/after/kyverno_policy_apply.txt`
- `evidence/after/kyverno_policy_status.txt`
- `evidence/after/kyverno_insecure_workload_denied.txt`
- `evidence/after/kyverno_hardened_workload_allowed.txt`
- `evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_get_credentials_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt`

Result:

- Managed Kubernetes node readiness validated.
- Kyverno admission controller installed.
- Kyverno ClusterPolicy applied and inspected.
- Insecure workload denied by admission policy.
- Hardened workload accepted by server-side admission validation.
- Temporary MKS resources destroyed after evidence collection.
<!-- phase-13-5-kyverno-admission:end -->

## Phase 13.6 — Final remediation metrics consolidation

Final remediation metrics consolidation artifacts:

- docs/final-remediation-metrics.md
- evidence/metrics/final_remediation_metrics.json
- evidence/metrics/final_remediation_metrics.txt
- evidence/command-outputs/YCSEC_13_6_OUTPUT_final_remediation_metrics.txt
- evidence/command-outputs/YCSEC_13_6_OUTPUT_final_git_control.txt

Validation scope:

- Terraform/IaC lifecycle evidence.
- GitHub Actions OIDC validation evidence.
- Audit Trails and evidence storage validation.
- Managed Kubernetes baseline/remediation evidence.
- Registry, SBOM, and vulnerability validation evidence.
- Kyverno admission policy enforcement evidence.
- Temporary resource cleanup evidence.

<!-- YCSEC:PHASE-13.7-FINAL-CONTROL-MATRIX:START -->

## Phase 13.7 — Final Control Matrix

Status: completed.

Artifacts:

- `docs/final-control-matrix.md`
- `evidence/metrics/final_control_matrix.json`
- `evidence/metrics/final_control_matrix.csv`
- `evidence/metrics/final_control_matrix.txt`
- `evidence/command-outputs/YCSEC_13_7_OUTPUT_final_control_matrix.txt`
- `evidence/command-outputs/YCSEC_13_7_OUTPUT_final_git_control.txt`

Purpose:

- Map validated IAM, OIDC, audit, Terraform, Managed Kubernetes, Kyverno, registry, SBOM, vulnerability, evidence hygiene, cleanup, and governance controls to public evidence.
- Define portfolio-safe claims based on committed evidence.
- Prepare the repository for final risk register and cloud-provider mapping phases.
<!-- YCSEC:PHASE-13.7-FINAL-CONTROL-MATRIX:END -->

<!-- YCSEC_PHASE_13_8_RISK_REGISTER_START -->

## Phase 13.8 — Final Risk Register

Status: completed.

Public artifacts:
- `docs/final-risk-register.md`
- `evidence/metrics/final_risk_register.json`
- `evidence/metrics/final_risk_register.csv`
- `evidence/metrics/final_risk_register.txt`
- `evidence/command-outputs/YCSEC_13_8_OUTPUT_final_risk_register.txt`
- `evidence/command-outputs/YCSEC_13_8_OUTPUT_final_git_control.txt`

Evidence value:
- consolidates final project risks;
- maps risks to validated controls and evidence;
- records residual risk and publication boundaries;
- separates validated claims from accepted design-level boundaries.
<!-- YCSEC_PHASE_13_8_RISK_REGISTER_END -->

<!-- YCSEC_PHASE_13_8_EVIDENCE_INDEX:START -->

## Phase 13.8 — Final Risk Register

Status: Completed.

Artifacts:

- `docs/final-risk-register.md`
- `evidence/metrics/final_risk_register.json`
- `evidence/metrics/final_risk_register.csv`
- `evidence/metrics/final_risk_register.txt`
- `evidence/command-outputs/YCSEC_13_8_OUTPUT_final_risk_register.txt`
- `evidence/command-outputs/YCSEC_13_8_OUTPUT_final_git_control.txt`

Validation result:

- Final risks are mapped to validated controls.
- Risk treatment is tied to evidence paths.
- Residual risk is explicitly recorded.
- Publication boundary is stated.
- No cloud resources were created in this phase.
<!-- YCSEC_PHASE_13_8_EVIDENCE_INDEX:END -->

## Phase 13.9 — Cross-cloud mapping and publication readiness

- `docs/final-cross-cloud-control-mapping.md` — AWS/GCP/Azure equivalent control mapping for validated Yandex Cloud controls.
- `docs/final-publication-readiness.md` — final publication boundary and remaining release tasks.
- `docs/retained-bootstrap-cleanup-plan.md` — cleanup order for retained bootstrap resources.
- `evidence/metrics/final_cross_cloud_control_mapping.json` — machine-readable cross-cloud mapping.
- `evidence/metrics/final_cross_cloud_control_mapping.csv` — tabular cross-cloud mapping.
- `evidence/metrics/final_cross_cloud_control_mapping.txt` — summary metrics for cross-cloud mapping.
- `evidence/command-outputs/YCSEC_13_9_OUTPUT_cross_cloud_publication_readiness.txt` — command evidence for this phase.
- `evidence/command-outputs/YCSEC_13_9_OUTPUT_final_git_control.txt` — final git control evidence for this phase.

## Phase 13.10 — Final RU/EN Reports and README Publication Polish

- `docs/final-technical-report-en.md` — final English technical report.
- `docs/final-technical-report-ru.md` — final Russian technical report.
- `README.md` — publication summary section updated.
- `evidence/metrics/final_publication_summary.json` — structured final publication summary.
- `evidence/metrics/final_publication_summary.txt` — text final publication summary.
- `evidence/command-outputs/YCSEC_13_10_OUTPUT_final_reports_readme.txt` — command evidence for this phase.
- `evidence/command-outputs/YCSEC_13_10_OUTPUT_final_git_control.txt` — final git control evidence.

## Phase 13.11 — retained bootstrap cleanup

Status: completed.

Evidence added:
- docs/retained-bootstrap-cleanup-evidence.md
- final registry, bucket, Audit Trails, service account, Managed Kubernetes, compute, and Network Load Balancer cleanup verification outputs

## Phase 13.12 — Checkov workflow stabilization

- `docs/iac-security-exceptions.md` — IaC security exception register for controlled evidence-run tradeoffs.
- `evidence/command-outputs/YCSEC_13_12_OUTPUT_checkov_after_exceptions.txt` — Checkov result after resource-scoped exception stabilization.
- `evidence/command-outputs/YCSEC_13_12_OUTPUT_final_git_control.txt` — final git control evidence for Phase 13.12.
