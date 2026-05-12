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
