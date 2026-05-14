# Kubernetes Baseline Findings

## Purpose

This document records the baseline security validation findings for the Kubernetes manifests in the Yandex Cloud Security Remediation Program.

The baseline result is intentionally used as the before state for the remediation workflow.

---

## Current Milestone

Current phase:

v0.12.2-kubernetes-baseline-static-validation

Previous phase:

v0.12.1-kubernetes-baseline-validation-plan

---

## Baseline Inventory

| Area | Count |
|---|---:|
| Kubernetes YAML manifests | 12 |
| Namespace files | 2 |
| Workload files | 2 |
| Service files | 3 |
| RBAC files | 2 |
| NetworkPolicy files | 3 |
| Pod Security label files | 2 |
| runAsNonRoot files | 2 |
| allowPrivilegeEscalation false files | 1 |
| capabilities/drop files | 1 |
| seccomp profile files | 1 |
| readOnlyRootFilesystem files | 2 |
| requests/limits files | 2 |
| policy-as-code references | 12 |

---

## Baseline Finding Summary

| Control ID | Control Area | Baseline Signal | Remediation Direction |
|---|---|---|---|
| K8S-BASE-001 | Namespace isolation | Namespace coverage measured | Add or refine namespace boundary where required |
| K8S-BASE-002 | Pod Security posture | Pod Security label coverage measured | Add enforce/audit/warn labels where compatible |
| K8S-BASE-003 | Non-root execution | runAsNonRoot coverage measured | Set runAsNonRoot true where compatible |
| K8S-BASE-004 | Privilege escalation | allowPrivilegeEscalation coverage measured | Set allowPrivilegeEscalation false |
| K8S-BASE-005 | Linux capabilities | capabilities/drop coverage measured | Drop ALL capabilities where compatible |
| K8S-BASE-006 | Seccomp | seccomp coverage measured | Set RuntimeDefault seccomp profile |
| K8S-BASE-007 | Root filesystem | readOnlyRootFilesystem coverage measured | Enable read-only root filesystem where compatible |
| K8S-BASE-008 | RBAC least privilege | RBAC object coverage measured | Use namespace-scoped least privilege bindings |
| K8S-BASE-009 | Network segmentation | NetworkPolicy coverage measured | Add default-deny and controlled allow-list policies |
| K8S-BASE-010 | Service exposure | Service exposure reviewed | Keep ClusterIP-first exposure model |
| K8S-BASE-011 | Resource governance | requests/limits coverage measured | Add explicit CPU/memory requests and limits |
| K8S-BASE-012 | Policy-as-code gate | policy-as-code coverage measured | Add repeatable validation gate |

---

## Evidence

| Evidence ID | File | Purpose |
|---|---|---|
| EVID-K8S-BASE-001 | evidence/command-outputs/YCSEC_12_2_OUTPUT_kubernetes_baseline_static_validation.txt | Baseline static validation command output |
| EVID-K8S-BASE-002 | docs/kubernetes-baseline-findings.md | Baseline finding summary |
| EVID-K8S-BASE-003 | evidence/before-after-metrics.md | Baseline metrics before remediation |

---

## Remediation Direction

The remediation phase should focus on measurable improvements in the following areas:

1. Pod Security labels.
2. securityContext hardening.
3. non-root execution.
4. privilege escalation prevention.
5. Linux capability reduction.
6. RuntimeDefault seccomp.
7. read-only root filesystem where compatible.
8. NetworkPolicy segmentation.
9. least-privilege RBAC.
10. resource requests and limits.
11. policy-as-code validation path.

---

## Portfolio Interpretation

This baseline document provides the before state of the Kubernetes security remediation cycle.

The value of the project is demonstrated by linking each baseline gap to a remediation control and then proving the improvement with repeatable command evidence.
