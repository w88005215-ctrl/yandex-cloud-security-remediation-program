# Kubernetes Baseline Control Matrix

## Purpose

This control matrix maps Kubernetes baseline risks to remediation controls and expected evidence.

It is used to keep the project focused on measurable security improvement instead of generic manifest editing.

---

## Control Matrix

| Control ID | Control | Baseline Validation | Remediation Control | Evidence |
|---|---|---|---|---|
| K8S-BASE-001 | Namespace isolation | Check namespaces and labels | Dedicated namespace with Pod Security labels | Baseline and remediation validation outputs |
| K8S-BASE-002 | Pod Security posture | Check pod-security.kubernetes.io labels | Enforce restricted or compatible policy level | Namespace manifest evidence |
| K8S-BASE-003 | Non-root execution | Check runAsNonRoot | Set runAsNonRoot true where compatible | Workload manifest evidence |
| K8S-BASE-004 | Privilege escalation | Check allowPrivilegeEscalation | Set allowPrivilegeEscalation false | Workload manifest evidence |
| K8S-BASE-005 | Linux capabilities | Check capabilities.drop | Drop ALL capabilities where compatible | Workload manifest evidence |
| K8S-BASE-006 | Seccomp | Check seccompProfile | Set RuntimeDefault | Workload manifest evidence |
| K8S-BASE-007 | Root filesystem | Check readOnlyRootFilesystem | Enable read-only root filesystem where compatible | Workload manifest evidence |
| K8S-BASE-008 | RBAC least privilege | Check ServiceAccount, Role, RoleBinding | Use namespace-scoped least privilege bindings | RBAC manifest evidence |
| K8S-BASE-009 | Network segmentation | Check NetworkPolicy presence | Add default-deny and allow-list policies | NetworkPolicy evidence |
| K8S-BASE-010 | Service exposure | Check Service type | Prefer ClusterIP unless external exposure is justified | Service manifest evidence |
| K8S-BASE-011 | Resource governance | Check requests and limits | Add explicit CPU/memory requests and limits | Workload manifest evidence |
| K8S-BASE-012 | Policy-as-code gate | Check policy references and validation path | Add policy validation workflow | Command evidence and policy files |

---

## Finding Severity Model

| Severity | Meaning |
|---|---|
| Critical | Control gap may allow direct privilege escalation, broad cluster impact or uncontrolled external exposure |
| High | Control gap materially weakens workload isolation, runtime hardening or network segmentation |
| Medium | Control gap reduces security assurance but has limited direct exploitability |
| Low | Documentation, consistency or hygiene gap |
| Informational | Observation useful for audit trail or future hardening |

---

## Remediation Evidence Rule

Every remediation claim must be backed by at least one of the following:

| Evidence Type | Location |
|---|---|
| Command output | evidence/command-outputs |
| Control documentation | docs |
| Before/after metric | evidence/before-after-metrics.md |
| Manifest change | kubernetes, k8s, manifests, policies or policy-as-code |
