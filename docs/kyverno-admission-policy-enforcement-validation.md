# Kyverno Admission Policy Enforcement Validation on Yandex Managed Kubernetes

## Purpose

This evidence block validates Kubernetes admission control enforcement in a real Yandex Managed Kubernetes environment.

The phase demonstrates that the project can move beyond static manifest validation and prove policy behavior at runtime:

- a short-lived Managed Kubernetes cluster is created;
- Kyverno is installed as an admission controller;
- a supply-chain admission policy is applied in enforcement mode;
- an intentionally insecure workload is rejected by admission control;
- a hardened workload using the validated Yandex Container Registry image passes server-side admission validation;
- all temporary Managed Kubernetes resources are destroyed after evidence collection.

## Scope

This phase validates admission behavior only. It does not retain the Managed Kubernetes cluster.

Retained bootstrap resources remain outside this short-lived run:

- Yandex Container Registry;
- Audit Trails trail;
- Object Storage audit bucket;
- GitHub Actions OIDC federation;
- bootstrap service accounts.

## Evidence summary

| Evidence area | Result |
|---|---|
| Managed Kubernetes cluster creation | Validated through Terraform apply evidence |
| Node readiness | Validated through `kubectl get nodes` evidence |
| Kyverno installation | Validated through install/apply evidence and controller readiness |
| Policy deployment | Validated through Kyverno ClusterPolicy apply/status evidence |
| Insecure workload denial | Validated through Kyverno-specific admission denial evidence |
| Hardened workload allow path | Validated through server-side dry-run allow evidence |
| Cleanup | Validated through Terraform destroy and post-destroy cloud inventory evidence |
| Secret/state safety | Validated through repository safety checks and gitleaks |

## Public evidence files

- `evidence/after/kyverno_mks_nodes_ready.txt`
- `evidence/after/kyverno_install_apply.txt`
- `evidence/after/kyverno_controller_pods_ready.txt`
- `evidence/after/kyverno_policy_apply.txt`
- `evidence/after/kyverno_policy_status.txt`
- `evidence/after/kyverno_insecure_workload_denied.txt`
- `evidence/after/kyverno_hardened_workload_allowed.txt`
- `evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_get_credentials_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt`

## Security interpretation

The result proves that the hardened supply-chain path is not only documented, but enforceable at Kubernetes admission time.

The insecure workload is blocked before persistence in the cluster. The hardened workload is accepted through server-side validation. This closes the policy-as-code runtime enforcement gap for the supply-chain extension.

## Cleanup result

The short-lived Managed Kubernetes cluster, node group, temporary VPC resources, and temporary MKS service accounts were destroyed after evidence collection.

Post-destroy evidence confirms that no temporary Managed Kubernetes resources remain visible in the Yandex Cloud inventory.
