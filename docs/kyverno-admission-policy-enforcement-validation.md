# Kyverno Admission Policy Enforcement Validation

## Status

Prepared for controlled rerun.

## Purpose

This phase validates Kubernetes admission policy enforcement on a short-lived Yandex Managed Kubernetes cluster.

The validation proves that:

- Kyverno admission controller can be installed on a real managed Kubernetes cluster.
- A controlled insecure workload is denied by admission policy.
- A hardened workload using the project registry image passes server-side admission validation.
- Managed Kubernetes resources are destroyed after evidence collection.
- No kubeconfig, Terraform state, IAM token, key, or raw private evidence is committed.

## Repair notes

The previous failed attempt exposed two implementation defects:

- kubeconfig was written by the cloud CLI to the default user kubeconfig path instead of the expected private evidence path;
- Terraform variable files included undeclared variables from a reused configuration pattern.

The repaired script isolates the kubeconfig workflow by using a private temporary HOME for Yandex CLI credential generation and then uses kubectl with an explicit private kubeconfig path.

The repaired Terraform runtime writes only variables declared by the Managed Kubernetes Terraform module.

## Evidence targets

Public evidence is expected under:

- evidence/after/kyverno_mks_nodes_ready.txt
- evidence/after/kyverno_install_apply.txt
- evidence/after/kyverno_controller_pods_ready.txt
- evidence/after/kyverno_policy_apply.txt
- evidence/after/kyverno_policy_status.txt
- evidence/after/kyverno_insecure_workload_denied.txt
- evidence/after/kyverno_hardened_workload_allowed.txt
- evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_get_credentials_sanitized.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt
- evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt

## Claim boundary

Allowed after successful rerun:

- Kyverno admission policy enforcement was validated on real Yandex Managed Kubernetes.
- A deliberately insecure workload was denied by admission control.
- A hardened workload passed admission validation.
- The managed cluster was destroyed after evidence collection.

Not allowed before successful rerun:

- Final admission-policy evidence is closed.

## Denial attribution control

The admission validation namespace intentionally does not use the `pod-security.kubernetes.io/enforce` label.

This prevents Kubernetes Pod Security Admission from taking ownership of the insecure workload denial. The expected denial evidence must reference Kyverno-specific admission behavior, policy names, rule names, webhook output, or Kyverno policy messages.

This makes the Phase 13.5B evidence stronger because the rejected workload is attributed to the project policy-as-code control rather than a default built-in Kubernetes restriction.

## Phase 13.5A2 runner hardening

The Kyverno Managed Kubernetes validation runner was hardened before the next paid rerun.

Corrections:

- Private evidence directory is initialized before the cleanup trap.
- Cleanup can run safely even if the script fails before Terraform runtime creation.
- Hardened image reference can be supplied explicitly through `YCSEC_HARDENED_IMAGE`.
- If no explicit image is supplied, the runner detects the hardened registry image tag from committed Phase 13.3/13.4 evidence.
- `yc managed-kubernetes cluster get-credentials` runs under isolated `HOME` and explicit `KUBECONFIG`.
- Terraform variables are limited to the declared Managed Kubernetes module contract.
- Kyverno denial evidence must be attributable to the Kyverno admission policy, not only to Kubernetes Pod Security Admission.
