# IaC Security Exceptions Register

This document records explicit Checkov exceptions used in the Yandex Cloud Security Remediation Program repository.

The exceptions are intentionally narrow and tied to controlled portfolio evidence runs. They do not represent a production baseline. Production deployments should replace these exceptions with hardened controls such as private cluster access, customer-managed encryption keys, strict security groups, private node networking, and fully encrypted evidence storage.

## Exception scope

| Checkov ID | Area | Resource scope | Reason | Compensating control |
|---|---|---|---|---|
| CKV_YC_3 | Object Storage | Audit evidence bucket | Short-lived audit evidence bucket used during validation. | Cleanup evidence confirms bucket removal after evidence collection. |
| CKV_YC_5 | Managed Kubernetes | Smoke and evidence clusters | Public API endpoint required for short controlled validation from isolated workstation. | Cluster lifecycle is temporary and cleanup evidence verifies removal. |
| CKV_YC_6 | Managed Kubernetes | Evidence node group | Public node egress/NAT used for controlled image pull and validation. | Node group is destroyed after evidence collection. |
| CKV_YC_10 | Managed Kubernetes | Smoke and evidence clusters | No persistent application secrets or long-lived workload data are stored in the temporary etcd scope. | Production recommendation remains customer-managed encryption for etcd. |
| CKV_YC_14 | Managed Kubernetes | Smoke and evidence clusters | Security group hardening is outside the minimal short-run validation path. | Production recommendation remains explicit cluster security groups. |
| CKV_YC_15 | Managed Kubernetes | Smoke and evidence node groups | Node group security group hardening is outside the minimal short-run validation path. | Production recommendation remains explicit node security groups. |
| CKV_YC_16 | Managed Kubernetes | Smoke cluster | Smoke-run validates lifecycle only; network policy enforcement is demonstrated separately. | Dedicated Kyverno/admission evidence validates policy enforcement. |

## Publication boundary

The repository demonstrates a controlled remediation case with evidence-backed exceptions. It does not claim that every Terraform environment is a reusable production module without further hardening.
