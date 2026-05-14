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
