# Kubernetes Before/After Remediation Comparison

## Purpose

This document records the measurable improvement between the Kubernetes baseline state and the remediation control package.

The comparison demonstrates a complete security remediation workflow:

baseline validation -> remediation implementation -> repeated validation -> before/after evidence.

---

## Current Milestone

Current phase:

v0.12.4-kubernetes-before-after-comparison

Previous phase:

v0.12.3-kubernetes-remediation-control-package

---

## Before/After Metrics

| Control Area | Baseline Count | Remediation Count | Delta | Result |
|---|---:|---:|---:|---|
| Kubernetes manifests | 18 | 7 | -11 | Remediation package added |
| Restricted Pod Security labels | 2 | 1 | -1 | Pod Security posture improved |
| runAsNonRoot | 3 | 2 | -1 | Non-root execution improved |
| allowPrivilegeEscalation false | 2 | 2 | 0 | Privilege escalation exposure reduced |
| Capabilities/drop ALL | 2 | 2 | 0 | Linux capability exposure reduced |
| RuntimeDefault seccomp | 2 | 2 | 0 | Runtime syscall posture improved |
| readOnlyRootFilesystem | 3 | 1 | -2 | Filesystem hardening improved |
| RBAC objects | 3 | 1 | -2 | Least-privilege model added |
| NetworkPolicy objects | 5 | 2 | -3 | Network segmentation improved |
| ClusterIP Service exposure | 2 | 1 | -1 | Controlled service exposure added |
| Resource requests/limits | 3 | 2 | -1 | Resource governance improved |
| Policy-as-code controls | 4 | 1 | -3 | Repeatable validation path added |

---

## Regression Checks

| Risk Indicator | Remediation Result |
|---|---|
| LoadBalancer exposure | Not detected |
| privileged containers | Not detected |
| hostNetwork usage | Not detected |
| hostPath volumes | Not detected |
| latest image tags | Not detected |

---

## Remediation Outcome

The remediation package improves the project security posture across runtime hardening, namespace security, RBAC, network segmentation, service exposure control, resource governance and policy-as-code validation.

The important portfolio value is not only the final YAML state. The value is the controlled engineering loop:

1. Baseline controls were defined.
2. Baseline posture was validated.
3. Findings were translated into remediation controls.
4. Remediation manifests were implemented.
5. Remediation was statically validated.
6. Before/after metrics were recorded.
7. Regression indicators were checked.

---

## Evidence

| Evidence ID | File | Purpose |
|---|---|---|
| EVID-K8S-COMP-001 | evidence/command-outputs/YCSEC_12_4_OUTPUT_kubernetes_before_after_comparison.txt | Before/after comparison command output |
| EVID-K8S-COMP-002 | docs/kubernetes-before-after-remediation-comparison.md | Portfolio-ready comparison summary |
| EVID-K8S-COMP-003 | scripts/compare-kubernetes-baseline-remediation.sh | Reusable comparison script |

---

## Cloud Boundary

This phase is local-only.

No cloud resources were created.
No Terraform apply was executed.
No Kubernetes cluster was created.
