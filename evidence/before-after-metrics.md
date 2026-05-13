# Before/After Remediation Metrics

## Purpose

This file tracks measurable security improvement across the project.

The goal is to prove that the project does not only deploy tools, but actually reduces risk.

## Metrics table

| Control Area | Before | After | Evidence |
|---|---:|---:|---|
| Static CI cloud credentials | TBD | TBD | EVID-OIDC-001 |
| GitHub cloud authentication | TBD | TBD | EVID-OIDC-002 |
| Long-lived service account keys in CI | TBD | TBD | EVID-OIDC-003 |
| IAM least privilege | TBD | TBD | EVID-IAM-001 |
| SAML/SSO federation pattern | TBD | TBD | EVID-SAML-001 |
| Terraform validation | TBD | TBD | EVID-IAC-001 |
| Checkov high findings | TBD | TBD | EVID-IAC-002 |
| Gitleaks findings | TBD | TBD | EVID-PUB-002 |
| Privileged Kubernetes pods | TBD | TBD | EVID-K8S-001 |
| Containers running as root | TBD | TBD | EVID-K8S-002 |
| Missing resource limits | TBD | TBD | EVID-K8S-003 |
| Writable root filesystem | TBD | TBD | EVID-K8S-004 |
| Missing NetworkPolicy | TBD | TBD | EVID-NET-001 |
| Broad RBAC permissions | TBD | TBD | EVID-K8S-005 |
| Pod Security Standards | TBD | TBD | EVID-K8S-006 |
| Kyverno policy enforcement | TBD | TBD | EVID-K8S-007 |
| Container image vulnerabilities | TBD | TBD | EVID-IMG-001 |
| SBOM availability | TBD | TBD | EVID-IMG-002 |
| Audit Trails coverage | TBD | TBD | EVID-AUD-001 |
| Evidence-to-control mapping | TBD | TBD | EVID-CTRL-001 |
| Cost-control process | Manual | Documented | EVID-COST-001 |
| Publication safety process | Manual | Documented | EVID-PUB-001 |

## Rules

- Before values must be based on evidence.
- After values must be based on evidence.
- If a finding remains, document it as residual risk.
- Do not claim 100% remediation unless evidence proves it.
- Prefer measurable values over vague statements.

## Residual risk notation

Use:

- Remediated
- Accepted risk
- Partially remediated
- Not applicable
- Deferred

## Reviewer note

This table will become one of the main portfolio artifacts. It should be easy to connect each row to command outputs, screenshots, scan reports and the final report.

## Phase 8 Kubernetes baseline metrics

| Control | Insecure baseline | Hardened state | Evidence |
|---|---|---|---|
| Runs as non-root | No | Yes | kubernetes/insecure-baseline, kubernetes/hardened |
| Privileged container | Yes | No | deployment securityContext |
| Privilege escalation | Allowed | Disabled | deployment securityContext |
| Read-only root filesystem | No | Yes | deployment securityContext |
| Linux capabilities | Not dropped | Drop ALL | deployment securityContext |
| Resource requests and limits | Missing | Present | deployment resources |
| Service exposure | NodePort | ClusterIP | service manifest |
| Namespace Pod Security | privileged | restricted | namespace labels |
| Network default deny | Missing | Present | NetworkPolicy manifests |
| RBAC least privilege | Missing | Present | RBAC manifests |
| Policy-as-code | Missing | Present | Kyverno policies |

## Phase 8 — Kubernetes static baseline metrics

| Area | Before | After | Evidence |
|---|---:|---:|---|
| Privileged workload example | Not documented | Documented as insecure baseline | kubernetes/insecure-baseline/demo-app-insecure.yaml |
| Root container example | Not documented | Documented as insecure baseline | kubernetes/insecure-baseline/demo-app-insecure.yaml |
| Hardened non-root workload | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Read-only root filesystem | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Dropped Linux capabilities | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| RuntimeDefault seccomp | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Default deny NetworkPolicy | Not documented | Documented | kubernetes/network-policies/default-deny.yaml |
| Kyverno policy-as-code | Not documented | Documented | kubernetes/kyverno-policies/ |
| Runtime enforcement | Not tested in Phase 8 | Deferred to Phase 9 | docs/en/kubernetes-security-model.md |
