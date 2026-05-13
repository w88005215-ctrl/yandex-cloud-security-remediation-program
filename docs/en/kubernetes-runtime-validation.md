# Kubernetes runtime validation

## Purpose

Phase 9 validates Kubernetes manifests against a temporary local Kubernetes API.

The goal is to prove that the Phase 8 manifests are not only statically valid, but are also accepted by a real Kubernetes API server.

## Validation model

Validation runs against an ephemeral local kind cluster.

This phase checks:

- namespace creation;
- insecure baseline application;
- hardened workload application;
- RBAC application;
- NetworkPolicy application;
- rejection of an unsafe privileged Pod in a restricted namespace through Pod Security Admission;
- deletion of the temporary local cluster after validation.

## Phase boundary

Phase 9 does not create Yandex Cloud resources.

Phase 9 does not run terraform apply.

Phase 9 does not use Managed Kubernetes.

Phase 9 does not store kubeconfig files in the repository.

