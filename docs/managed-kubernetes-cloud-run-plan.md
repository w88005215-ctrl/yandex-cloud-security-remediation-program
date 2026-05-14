# Managed Kubernetes Baseline and Remediation Cloud-Run Plan

## Status

Planned.

## Purpose

This phase defines the next controlled cloud-run for the project: a short-lived Yandex Managed Kubernetes session that demonstrates insecure baseline deployment, security findings collection, remediation and hardening, before/after comparison, audit evidence collection, and controlled destroy.

## Roadmap position

Previous closed blocks:

- Yandex Cloud bootstrap resources exist.
- GitHub Actions OIDC token exchange is validated.
- Audit Trails delivery is validated.
- Container Registry and Object Storage retention are validated.
- Kubernetes baseline and remediation static package exists.

This phase prepares the next real cloud evidence run.

## Cloud-run boundary

| Resource type | Policy |
|---|---|
| Managed Kubernetes cluster | Allowed for short controlled run |
| Worker node group | Allowed, minimum viable size |
| Compute instances | Allowed only as Kubernetes worker nodes |
| Load Balancer | Avoid unless explicitly required |
| Managed databases | Not allowed |
| GPU | Not allowed |
| Marketplace images | Not allowed |
| Heavy observability stack | Not allowed |
| Bootstrap IAM/OIDC/Audit resources | Retain until cloud evidence is complete |

## Execution model

The preferred model is one short controlled cloud session:

1. Create minimal Managed Kubernetes cluster.
2. Confirm node readiness.
3. Apply insecure baseline.
4. Collect before evidence.
5. Apply remediation and hardening controls.
6. Collect after evidence.
7. Collect Audit Trails evidence.
8. Update before/after metrics.
9. Destroy Managed Kubernetes resources.
10. Verify no Kubernetes, Compute, or Load Balancer resources remain from the run.

## Success criteria

The phase is successful only if the repository contains sanitized evidence proving:

- Managed Kubernetes cluster was created.
- Node became Ready.
- Insecure baseline was deployed.
- Baseline findings were detected.
- Hardened state was applied.
- Before/after posture improved.
- Audit Trails recorded cloud control-plane activity.
- Managed Kubernetes resources were destroyed after evidence collection.
- No Terraform state, kubeconfig, credentials, or raw private evidence were committed.

## Portfolio claim boundary

Allowed after the cloud-run:

Managed Kubernetes baseline and remediation were validated in a real Yandex Cloud environment with evidence-backed before/after results.

Not allowed until the cloud-run is complete:

Production Kubernetes hardening was fully validated in cloud.
