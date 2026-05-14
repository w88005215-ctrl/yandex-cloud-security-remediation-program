# Managed Kubernetes Cloud-Run Operator Runbook

## Phase

Phase 13.0 controlled cloud-run.

## Preconditions

- Phase 12.9 is complete.
- Phase 13.0A implementation package is committed.
- Bootstrap OIDC/Audit resources are retained.
- GitHub Actions OIDC validation is complete.
- Audit Trails delivery is validated.
- Registry and evidence storage validation is complete.
- Budget and promo balance are reviewed.
- Repository contains no Terraform state, kubeconfig, token, key, or raw private evidence.

## Execution command

Run only after explicit operator approval:

YCSEC_CONFIRM_MKS_CLOUD_RUN=YES ./scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh

Default behavior destroys Managed Kubernetes resources after evidence collection.

## Optional retention override

Use only if evidence collection fails and cleanup must be performed manually:

YCSEC_CONFIRM_MKS_CLOUD_RUN=YES YCSEC_DESTROY_MKS_AFTER_RUN=NO ./scripts/run-managed-kubernetes-baseline-remediation-cloud-run.sh

## Expected evidence

Before evidence:

- Managed Kubernetes cluster created.
- Node readiness confirmed.
- Insecure baseline applied.
- Baseline workload and RBAC state captured.
- Scanner output collected where tools are available.

After evidence:

- Hardened namespace and workload applied.
- Pod Security labels captured.
- RBAC can-i evidence captured.
- NetworkPolicy evidence captured.
- After scanner output collected where tools are available.

Destroy evidence:

- Terraform destroy output.
- Post-destroy Managed Kubernetes inventory.
- Post-destroy Compute inventory.
- Post-destroy Network Load Balancer inventory.
- Confirmation that bootstrap OIDC/Audit resources remain available.
