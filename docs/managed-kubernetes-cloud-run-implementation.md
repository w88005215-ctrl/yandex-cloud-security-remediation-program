# Managed Kubernetes Cloud-Run Implementation Package

## Status

Implemented as a local package. No Managed Kubernetes cloud resources are created by this phase.

## Purpose

This package prepares the controlled cloud evidence run for the Yandex Cloud Security Remediation Program. The next run validates insecure Kubernetes baseline, remediation, before and after security posture, audit evidence, and controlled destroy in a real Yandex Managed Kubernetes environment.

## Package contents

- Terraform environment for short-lived Managed Kubernetes resources.
- Controlled cloud-run script with explicit approval gate.
- Insecure baseline manifests.
- Hardened remediation manifests.
- Kyverno policy-as-code controls.
- Static validator.
- Operator runbook.

## Terraform boundary

The Terraform environment creates only the resources required for a short controlled Managed Kubernetes evidence run:

- temporary VPC network;
- temporary subnet;
- Managed Kubernetes cluster;
- minimal worker node group;
- cluster and node service accounts;
- required IAM bindings.

It must not create GPU resources, Marketplace resources, managed databases, long-lived observability stacks, or external load balancers unless explicitly added later.

## Vulnerability demonstration

The insecure baseline intentionally includes controlled Kubernetes weaknesses:

- privileged container;
- root execution;
- privilege escalation;
- writable root filesystem;
- added Linux capabilities;
- mutable latest image tag;
- missing resource requests and limits;
- over-permissive RBAC;
- service account token automount;
- missing default-deny NetworkPolicy.

The hardened state remediates these areas with non-root execution, restricted security context, read-only root filesystem, dropped capabilities, seccomp RuntimeDefault, resource governance, least-privilege RBAC, NetworkPolicy, and policy-as-code.

## Claim boundary

Allowed after this phase:

Managed Kubernetes cloud-run implementation package is ready for controlled execution.

Not allowed after this phase alone:

Managed Kubernetes baseline/remediation was validated in cloud.
