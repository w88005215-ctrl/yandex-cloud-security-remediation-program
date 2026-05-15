# Managed Kubernetes Evidence Collection Plan

## Evidence groups

| Group | Evidence target |
|---|---|
| MKS lifecycle | cluster create, node readiness, destroy, zero-resource check |
| Insecure baseline | manifests applied, pod/service/RBAC state, scanner findings |
| Remediation | hardened manifests, PSS labels, RBAC, NetworkPolicy, Kyverno policies |
| Before/after metrics | finding count, control status, residual risk |
| Audit Trails | cloud control-plane events related to cluster lifecycle and IAM/API usage |
| CI/OIDC | GitHub Actions OIDC already validated and reused as identity evidence |
| Cost control | short run, no retained Managed Kubernetes resources |

## Before evidence

Planned files:

- evidence/before/yc_mks_cluster_created.txt
- evidence/before/yc_mks_nodes_ready.txt
- evidence/before/kubectl_get_all_insecure.txt
- evidence/before/kubernetes_baseline_findings_cloud.txt
- evidence/before/trivy_k8s_before.txt
- evidence/before/kube_score_before.txt
- evidence/before/kubescape_before.txt

## After evidence

Planned files:

- evidence/after/kubectl_get_all_hardened.txt
- evidence/after/kubectl_auth_can_i.txt
- evidence/after/network_policy_validation.txt
- evidence/after/pod_security_labels.txt
- evidence/after/kyverno_policy_validation.txt
- evidence/after/trivy_k8s_after.txt
- evidence/after/kube_score_after.txt
- evidence/after/kubescape_after.txt

## Audit evidence

Planned files:

- evidence/sanitized/audit_trails_mks_lifecycle_redacted.txt
- evidence/sanitized/audit_trails_k8s_cloud_run_redacted.txt

## Final evidence

Planned files:

- evidence/command-outputs/YCSEC_13_0_OUTPUT_managed_kubernetes_baseline_remediation_cloud_run.txt
- <curated-publication-noise-artifact>
- docs/managed-kubernetes-cloud-run-results.md
- docs/managed-kubernetes-before-after-cloud-comparison.md
