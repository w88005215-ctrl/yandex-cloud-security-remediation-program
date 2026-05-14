# Kubernetes Security Remediation Case Study

## Project Context

This case study documents the Kubernetes security remediation track of the Yandex Cloud Security Remediation Program.

The work demonstrates a practical security engineering lifecycle:

readiness inventory -> baseline validation plan -> baseline static validation -> remediation control package -> before/after comparison -> portfolio-ready evidence.

The objective is not only to provide Kubernetes manifests, but to show a controlled remediation workflow with measurable improvement, repeatable validation and publication-safe evidence.

The central remediation workflow is: baseline validation -> remediation implementation -> repeated validation -> before/after evidence.

---

## Executive Summary

The Kubernetes remediation track converts a baseline security posture into a hardened, evidence-backed remediation package.

The implemented remediation layer includes:

| Area | Implemented Control |
|---|---|
| Namespace isolation | Dedicated remediated namespace |
| Pod Security | restricted enforce/audit/warn labels |
| Runtime hardening | non-root execution, privilege escalation prevention, dropped capabilities |
| Seccomp | RuntimeDefault syscall profile |
| Filesystem hardening | read-only root filesystem with writable temporary mounts |
| RBAC | namespace-scoped ServiceAccount, Role and RoleBinding |
| Network segmentation | default-deny and controlled allow-list NetworkPolicy |
| Service exposure | ClusterIP-only Service |
| Resource governance | CPU and memory requests and limits |
| Policy-as-code | Kyverno ClusterPolicy package in Audit mode |
| Validation | reusable baseline, remediation and comparison scripts |

---

## Engineering Problem

A Kubernetes environment can appear functional while still lacking strong workload isolation, runtime restrictions, network segmentation, RBAC discipline and repeatable validation.

The remediation problem addressed here is:

How to convert Kubernetes baseline findings into concrete hardening controls and prove the improvement with evidence.

---

## Methodology

The remediation track uses a staged security engineering process.

| Stage | Purpose | Output |
|---|---|---|
| Readiness inventory | Identify Kubernetes assets and validation prerequisites | docs/kubernetes-remediation-readiness.md |
| Baseline validation plan | Define controls, findings and success criteria | docs/kubernetes-baseline-validation-plan.md |
| Control matrix | Map baseline risks to remediation controls | docs/kubernetes-baseline-control-matrix.md |
| Baseline static validation | Measure before-state control coverage | docs/kubernetes-baseline-findings.md |
| Remediation package | Implement hardening controls | kubernetes/remediation and policies/kyverno |
| Remediation validation | Verify remediation controls locally | scripts/validate-kubernetes-remediation-static.sh |
| Before/after comparison | Prove measurable improvement | docs/kubernetes-before-after-remediation-comparison.md |

---

## Remediation Package Inventory

| Area | Count |
|---|---:|
| Remediation YAML manifests | 7 |
| NetworkPolicy files | 2 |
| RBAC files | 1 |
| Restricted Pod Security label files | 1 |
| Runtime hardening files | 2 |
| Policy-as-code files | 1 |

---

## Implemented Controls

### Namespace and Pod Security

The remediation package defines a dedicated namespace with restricted Pod Security labels.

This creates a clear security boundary and makes the expected pod security posture explicit at the namespace level.

### Runtime Hardening

The hardened workload specification implements:

- non-root execution;
- disabled privilege escalation;
- dropped Linux capabilities;
- RuntimeDefault seccomp profile;
- read-only root filesystem;
- explicit writable temporary mounts only where required.

### RBAC Least Privilege

The remediation package uses a namespace-scoped ServiceAccount, Role and RoleBinding.

The service account token is not automatically mounted into the workload, reducing unnecessary credential exposure.

### Network Segmentation

The remediation package includes:

- default-deny ingress and egress policy;
- controlled allow-list policy for required application and DNS traffic.

This demonstrates segmentation-by-default rather than unrestricted pod communication.

### Controlled Service Exposure

The Service is ClusterIP-only.

No LoadBalancer exposure is introduced by the remediation package.

### Resource Governance

The hardened workload defines CPU and memory requests and limits.

This improves operational predictability and reduces uncontrolled resource consumption risk.

### Policy-as-Code

A Kyverno ClusterPolicy package captures baseline expectations as repeatable validation rules.

The policy is set to Audit mode, which is suitable for controlled validation and phased enforcement.

---

## Validation Evidence

| Evidence Area | File |
|---|---|
| Baseline validator | scripts/validate-kubernetes-baseline-static.sh |
| Remediation validator | scripts/validate-kubernetes-remediation-static.sh |
| Before/after comparison | scripts/compare-kubernetes-baseline-remediation.sh |
| Baseline findings | docs/kubernetes-baseline-findings.md |
| Remediation results | docs/kubernetes-remediation-results.md |
| Before/after comparison | docs/kubernetes-before-after-remediation-comparison.md |
| Command evidence | evidence/command-outputs |

---

## Security Outcome

The Kubernetes remediation track demonstrates:

1. Baseline security posture can be measured locally.
2. Findings can be mapped to explicit remediation controls.
3. Remediation controls can be implemented as Kubernetes manifests.
4. Controls can be validated repeatedly through scripts.
5. Improvement can be expressed through before/after metrics.
6. The project can preserve audit-ready evidence without exposing sensitive runtime artifacts.

---

## Portfolio Value

This case demonstrates practical capability in:

- Kubernetes security hardening;
- cloud security remediation planning;
- policy-as-code design;
- evidence-driven validation;
- least-privilege RBAC;
- workload runtime security;
- network segmentation;
- secure publication of technical artifacts;
- before/after remediation measurement.

The result is a portfolio-ready cloud security engineering case that shows not only implementation skills, but also security program thinking: baseline, control design, remediation, validation, evidence and measurable outcomes.

---

<!-- YCSEC:CASE-STUDY-PORTFOLIO-VALUE:START -->
## Reviewer-Facing Value

This case is structured to be reviewed as an engineering artifact, not as a simple laboratory exercise.

A technical reviewer can verify:

| Reviewer Question | Project Evidence |
|---|---|
| Was there a baseline? | Baseline validation plan and baseline findings |
| Were the gaps mapped to controls? | Kubernetes baseline control matrix |
| Were remediation controls implemented? | Kubernetes remediation manifests and Kyverno policy package |
| Was remediation validated? | Remediation static validator and command evidence |
| Was improvement measured? | Before/after comparison document and metrics |
| Was publication safety considered? | Sanitized evidence model and absence of runtime secrets/state |

The case demonstrates practical cloud security remediation discipline: controlled scope, explicit security controls, repeatable validation, documented evidence and measurable improvement.
<!-- YCSEC:CASE-STUDY-PORTFOLIO-VALUE:END -->


## Cloud Boundary

This phase is local-only.

No cloud resources were created.
No Terraform apply was executed.
No Kubernetes cluster was created.
