# Bootstrap/OIDC/Audit Cloud-Run Results

## Result

Phase 12.8B completed the controlled Bootstrap/OIDC/Audit provisioning track.

The cloud-run established the bootstrap identity, registry, and audit foundation required for the next roadmap steps:

- GitHub Actions service account for OIDC-based cloud access.
- Workload Identity Federation for GitHub Actions.
- Federated credential scoped to the configured GitHub repository and branch.
- Container Registry for controlled image delivery evidence.
- Object Storage bucket for Audit Trails delivery.
- Audit Trails trail for cloud control-plane evidence.

## Repair performed

The initial apply created identity, federation, credential, IAM binding, and registry resources, but Object Storage creation failed because the generated bucket name contained an uppercase timestamp separator. The bucket-name generation logic was corrected to use lowercase timestamps, and the preserved private Terraform runtime was reused to complete Object Storage and Audit Trails provisioning.

## Current state

Bootstrap resources are intentionally retained temporarily for the next validation steps:

- GitHub OIDC validation.
- Audit Trails event collection.
- Container Registry workflow validation.
- Evidence export and sanitization.

No Managed Kubernetes cluster, Compute instance, or Network Load Balancer is created by this phase.

## Container Registry scanner note

The registry may show a console notice that vulnerability scanning is not configured. This is non-blocking for the bootstrap phase because no image security validation is performed here. Image scanning and registry security gates are handled in the later CI/image-security validation track.

## Cleanup model

Terraform runtime and state are preserved outside the public repository under the private evidence area. Cleanup must be performed after OIDC, Audit Trails, and registry validation using the preserved Terraform runtime.

## Publication safety

Public repository artifacts contain sanitized evidence only. Terraform state, kubeconfig files, cloud tokens, service account keys, and raw private runtime files are not stored in the repository.
