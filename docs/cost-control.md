# Cost Control

## Purpose

This project uses a limited Yandex Cloud promo budget. Cloud resources must be created only when they are needed for evidence collection.

The operating model is:

local preparation -> short cloud evidence run -> evidence collection -> cost check -> destroy

## Budget

Available promo budget:

- 4000 RUB

Promo code must not be activated until local Terraform, Kubernetes manifests, CI/CD checks and evidence model are ready.

## Cost risk areas

High-risk resources:

| Resource | Risk | Rule |
|---|---|---|
| Managed Kubernetes master | Continuous cost while running | Use only during short evidence runs |
| Compute node group | VM cost while running | Destroy after Kubernetes evidence collection |
| Public IP | May generate cost and exposure | Avoid unless required |
| Network Load Balancer | Additional cost | Do not use by default |
| Large disks | Storage cost | Use minimal sizes |
| Heavy observability stacks | Compute and storage cost | Avoid in this project |
| Managed databases | Unnecessary cost | Do not use |
| Marketplace images | Promo limitations / extra risk | Do not use |
| GPU | Not covered by project scope | Do not use |
| Support / Postbox | Out of scope | Do not use |

## Allowed low-risk resources

Allowed when needed:

- IAM service accounts;
- Workload Identity Federation configuration;
- Container Registry;
- Object Storage bucket for evidence or audit delivery;
- Audit Trails;
- Cloud Logging where useful;
- minimal network resources.

Even low-risk resources must be documented in the resource inventory.

## Pre-cloud-run checklist

Before any terraform apply or cloud action:

| Check | Status |
|---|---|
| Budget documented | Required |
| Promo code active only when ready | Required |
| Expected resources listed | Required |
| Terraform plan saved | Required |
| Destroy checklist prepared | Required |
| Evidence directory prepared | Required |
| Secrets not committed | Required |
| .gitignore reviewed | Required |
| No Terraform state in Git | Required |
| No kubeconfig in Git | Required |
| No service account keys in Git | Required |

## Before terraform apply

The assistant must stop before paid cloud actions and require explicit confirmation.

Required information before apply:

- purpose of the action;
- resources that will be created;
- cost risk;
- evidence to be collected;
- rollback or destroy procedure.

## After every cloud-run

Required actions:

1. Collect evidence.
2. Save screenshots if needed.
3. Save command outputs.
4. Export or inspect audit logs.
5. Redact sensitive data.
6. Check costs.
7. Update docs/resource-inventory.md.
8. Destroy expensive resources if they are not needed.
9. Confirm no Managed Kubernetes cluster or node group remains running without purpose.

## Kubernetes cost rule

Managed Kubernetes must be used only for a short evidence run.

Default service exposure model:

- ClusterIP
- kubectl port-forward
- command output
- screenshots

Do not create LoadBalancer services unless explicitly needed for evidence.

## Cloud-run decision rule

If the same result can be tested locally, test it locally first.

Only use Yandex Cloud for evidence that requires real managed infrastructure, such as:

- Workload Identity Federation;
- Audit Trails evidence;
- real Managed Kubernetes cluster evidence;
- IAM/service account evidence;
- Container Registry evidence.
