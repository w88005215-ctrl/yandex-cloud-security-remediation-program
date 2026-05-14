# Managed Kubernetes Destroy and Retention Plan

## Retain

The following bootstrap resources remain retained until all cloud evidence stages are complete:

- GitHub Actions service account
- Audit Trails service account
- Workload Identity OIDC federation
- Federated credential
- Container Registry
- Object Storage audit/evidence bucket
- Audit Trails trail

## Destroy after Managed Kubernetes cloud-run

The following resources must be destroyed after the Managed Kubernetes evidence run:

- Managed Kubernetes cluster
- Kubernetes node group
- Compute instances created for worker nodes
- Any Network Load Balancer created by Kubernetes services
- Any temporary public IPs created by the run
- Any temporary cloud resources created only for the Kubernetes run

## Required post-destroy checks

The cloud-run is not complete until evidence shows:

- no YCSEC Managed Kubernetes cluster remains
- no YCSEC worker Compute instance remains
- no YCSEC Network Load Balancer remains
- no temporary Kubernetes public IP remains
- bootstrap OIDC/Audit resources remain available

## Terraform state handling

Terraform runtime and state must remain outside the public repository. Public evidence must be sanitized.
