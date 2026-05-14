# Portfolio Claims Policy

## Purpose

This document defines what can and cannot be claimed about the project at the current stage.

It prevents overstating project maturity before the remaining cloud evidence is collected.

---

## Allowed Claims Now

At the current milestone, it is accurate to claim:

| Claim | Status |
|---|---|
| The project includes a Yandex Cloud Managed Kubernetes lifecycle smoke-run | Allowed |
| Terraform successfully created temporary Managed Kubernetes infrastructure during the smoke-run | Allowed |
| kubectl access and Ready node state were confirmed during the smoke-run | Allowed |
| Terraform destroy and zero-resource cleanup were confirmed after the smoke-run | Allowed |
| Kubernetes baseline and remediation controls were designed and validated locally/static | Allowed |
| The repository includes Kubernetes remediation manifests, RBAC, NetworkPolicy and Kyverno policies | Allowed |
| The Kubernetes remediation track includes before/after static comparison | Allowed |
| The Kubernetes remediation track is packaged as a portfolio case study | Allowed |
| The project follows a cost-controlled short-run cloud evidence strategy | Allowed |

---

## Claims Not Allowed Yet

The following claims must not be made until additional evidence exists:

| Claim | Reason |
|---|---|
| The entire project is complete | Missing cloud evidence tracks remain |
| Final portfolio release is ready | Final reports, risk register, mapping and publication safety are not complete |
| GitHub Actions OIDC/WIF is fully implemented and proven | OIDC/WIF cloud evidence is not closed |
| SAML/SSO federation is fully implemented and proven | SAML/SSO evidence is not closed |
| Audit Trails evidence is complete | Audit event export/redaction is not closed |
| Managed Kubernetes insecure baseline cloud-run is complete | Real baseline cloud-run has not been performed |
| Managed Kubernetes remediation cloud-run is complete | Real after-state cloud-run has not been performed |
| Final before/after remediation metrics are complete | Current metrics are static/local, not fully cloud-backed |
| The project has final control matrix and risk register | These documents still need final evidence-linked versions |

---

## Reviewer-Safe Summary

Current reviewer-safe summary:

The repository currently demonstrates a cost-controlled Yandex Cloud Managed Kubernetes smoke-run and a complete local/static Kubernetes remediation track with evidence, validation scripts, remediation manifests, policy-as-code and before/after comparison. The next workstream is to close the remaining roadmap cloud evidence gaps for IAM/OIDC, audit logging, bootstrap resources and real Managed Kubernetes baseline/remediation runs.

---

## Release Gate

Final release packaging is blocked until the following are complete:

1. Bootstrap/OIDC/Audit cloud-run evidence.
2. Managed Kubernetes baseline cloud-run evidence.
3. Managed Kubernetes remediation cloud-run evidence.
4. Audit evidence package.
5. Cloud-backed before/after remediation metrics.
6. Final control matrix.
7. Final risk register.
8. AWS/GCP/Azure mapping.
9. RU/EN final reports.
10. Final publication safety pass.
