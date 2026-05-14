# Kubernetes Baseline Validation Plan

## Purpose

This document defines the Kubernetes baseline validation plan for the Yandex Cloud Security Remediation Program.

The goal of this stage is to convert the existing Kubernetes inventory into a measurable security validation workflow:

baseline state -> findings -> remediation controls -> repeated validation -> before/after evidence.

This is not a generic Kubernetes checklist. It is a controlled security engineering workflow designed to demonstrate practical cloud security remediation, evidence handling and measurable improvement.

---

## Current Project Milestone

Current completed milestone:

v0.12.0-kubernetes-remediation-readiness

Current phase target:

v0.12.1-kubernetes-baseline-validation-plan

---

## Baseline Inventory Summary

| Area | Count |
|---|---:|
| Kubernetes YAML manifests | 12 |
| Namespace files | 2 |
| Workload files | 2 |
| Service files | 3 |
| RBAC files | 2 |
| NetworkPolicy files | 3 |
| SecurityContext files | 5 |
| Pod Security files | 2 |
| Policy-as-code references | 11 |

---

## Validation Objective

The baseline validation must answer four engineering questions:

| Question | Expected Output |
|---|---|
| What is currently deployed or prepared for deployment? | Manifest inventory and object classification |
| Which security controls are missing or weak? | Baseline findings |
| Which remediation controls close the gaps? | Hardened manifests and policy controls |
| How is improvement proven? | Before/after validation evidence and metrics |

---

## Baseline Control Areas

The baseline validation will assess the following control areas.

| Control ID | Control Area | Baseline Risk | Remediation Direction |
|---|---|---|---|
| K8S-BASE-001 | Namespace isolation | Workloads may not be separated by security boundary | Dedicated namespace model with Pod Security labels |
| K8S-BASE-002 | Pod Security posture | Workloads may allow insecure runtime behavior | Restricted Pod Security profile where applicable |
| K8S-BASE-003 | Container privilege model | Containers may allow privilege escalation or root execution | runAsNonRoot, allowPrivilegeEscalation false, dropped capabilities |
| K8S-BASE-004 | Filesystem hardening | Containers may use writable root filesystem unnecessarily | readOnlyRootFilesystem where workload-compatible |
| K8S-BASE-005 | Seccomp profile | Runtime syscall profile may be unspecified | RuntimeDefault seccomp profile |
| K8S-BASE-006 | RBAC scope | Service accounts may have excessive or unclear permissions | Least-privilege Role and RoleBinding model |
| K8S-BASE-007 | Network segmentation | Pods may communicate without explicit restrictions | Default-deny and controlled allow-list NetworkPolicy |
| K8S-BASE-008 | Service exposure | Services may expose workloads more broadly than required | ClusterIP-first exposure model and controlled ingress boundary |
| K8S-BASE-009 | Resource governance | Workloads may lack CPU and memory requests or limits | Explicit requests and limits |
| K8S-BASE-010 | Policy enforcement | Controls may exist as documentation only | Policy-as-code validation gates |

---

## Expected Baseline Findings

The baseline phase is expected to identify and classify security gaps such as:

| Finding Class | Example Evidence |
|---|---|
| Missing Pod Security labels | Namespace manifests without enforce/audit/warn labels |
| Missing securityContext | Workload manifests without pod or container security context |
| Privilege escalation not disabled | Container security context missing allowPrivilegeEscalation false |
| Root execution not restricted | Missing runAsNonRoot |
| Linux capabilities not constrained | Missing capabilities.drop |
| Missing seccomp profile | Missing seccompProfile RuntimeDefault |
| Missing NetworkPolicy | Namespace without default-deny or controlled allow policy |
| Overbroad RBAC | ClusterRole or broad RoleBinding where namespace Role is sufficient |
| Missing resource limits | Workload containers without requests and limits |
| Weak evidence traceability | Controls not linked to command output or metrics |

---

## Validation Method

Baseline validation should be performed in three stages:

| Stage | Activity | Output |
|---|---|---|
| Static manifest review | Parse and inspect YAML manifests | Baseline finding inventory |
| Policy/control mapping | Map findings to control IDs | Control matrix update |
| Evidence capture | Save validation output to evidence/command-outputs | Audit-ready command evidence |

No cloud resources are required for this planning phase.

---

## Evidence Model

Expected evidence for the next validation phases:

| Evidence ID | Evidence File | Purpose |
|---|---|---|
| EVID-K8S-BASE-001 | evidence/command-outputs/YCSEC_12_2_OUTPUT_kubernetes_baseline_static_validation.txt | Baseline static validation output |
| EVID-K8S-BASE-002 | docs/kubernetes-baseline-findings.md | Baseline finding summary |
| EVID-K8S-BASE-003 | evidence/before-after-metrics.md | Baseline metrics before remediation |
| EVID-K8S-REM-001 | evidence/command-outputs/YCSEC_12_3_OUTPUT_kubernetes_remediation_static_validation.txt | Remediation validation output |
| EVID-K8S-REM-002 | docs/kubernetes-remediation-results.md | Remediation result summary |
| EVID-K8S-REM-003 | evidence/before-after-metrics.md | After-remediation metrics |

---

## Success Criteria

Phase 12 baseline/remediation work is successful when:

| Criterion | Required Result |
|---|---|
| Baseline findings are identified | Yes |
| Findings are mapped to controls | Yes |
| Remediation controls are implemented | Yes |
| Validation is repeated after remediation | Yes |
| Before/after metrics show improvement | Yes |
| Evidence is stored under evidence/command-outputs | Yes |
| Public documents avoid sensitive runtime artifacts | Yes |

---

## Portfolio Value

This stage demonstrates the ability to build a security remediation program rather than only deploy infrastructure.

It shows:

- Kubernetes security baseline design;
- control-oriented validation;
- practical hardening workflow;
- evidence-driven remediation;
- before/after measurement;
- publication-safe cloud security engineering discipline.
