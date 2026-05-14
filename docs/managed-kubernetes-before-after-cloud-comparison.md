# Managed Kubernetes Before/After Cloud Comparison

## Status

Completed.

## Purpose

This document records the cloud evidence boundary for the Managed Kubernetes baseline/remediation validation.

## Before state

The insecure baseline was designed to demonstrate controlled Kubernetes security weaknesses:

| Area | Baseline evidence |
|---|---|
| Privileged workload / weak security context | evidence/before/kubectl_get_all_insecure.txt and baseline manifests |
| Over-permissive RBAC | evidence/before/kubectl_apply_insecure_baseline.txt and baseline manifests |
| Mutable image pattern | baseline workload manifest |
| Scanner findings | evidence/before/trivy_k8s_before.txt and evidence/before/kube_score_before.txt |

## After state

The hardened/remediated state introduced Kubernetes hardening controls:

| Area | Remediation evidence |
|---|---|
| Hardened workload security context | evidence/after/kubectl_get_all_hardened.txt |
| Least-privilege RBAC | evidence/after/kubectl_auth_can_i.txt |
| NetworkPolicy controls | evidence/after/network_policy_validation.txt |
| Pod security labels | evidence/after/pod_security_labels.txt |
| Scanner re-check | evidence/after/trivy_k8s_after.txt and evidence/after/kube_score_after.txt |

## Resource lifecycle

| Lifecycle control | Evidence |
|---|---|
| Cluster created and used for validation | command output and Terraform apply evidence |
| Kubernetes evidence collected | evidence/before and evidence/after |
| Managed Kubernetes resources destroyed | Terraform destroy evidence |
| Post-destroy inventory checked | cluster, compute, and load balancer list outputs |

## Interpretation

The cloud-run demonstrates a practical remediation workflow:

1. Deploy insecure baseline.
2. Collect findings and operational state.
3. Apply hardened configuration.
4. Collect after-remediation evidence.
5. Destroy cloud resources.
6. Preserve only sanitized public evidence.

This supports a portfolio-grade cloud security remediation narrative without retaining unnecessary paid Kubernetes resources.
