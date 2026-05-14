# Managed Kubernetes Baseline/Remediation Cloud-Run Results

## Status

Completed.

## Phase

Phase 13.0 — controlled Managed Kubernetes baseline/remediation cloud-run.

## Summary

A short-lived Yandex Managed Kubernetes cloud-run was executed to validate the project Kubernetes security remediation case in a real managed cloud environment.

The run created Managed Kubernetes resources, applied an insecure baseline, collected before evidence, applied hardened/remediated manifests, collected after evidence, and destroyed Managed Kubernetes resources after evidence collection.

## Confirmed outcomes

| Control area | Result |
|---|---|
| Managed Kubernetes creation | Completed |
| Node readiness evidence | Collected |
| Insecure baseline deployment | Collected |
| Baseline scanner evidence | Collected |
| Hardened deployment | Collected |
| After-remediation scanner evidence | Collected |
| RBAC validation | Collected |
| NetworkPolicy validation | Collected |
| Pod security context validation | Collected |
| Terraform destroy | Completed |
| Post-destroy cluster inventory | Collected |
| Post-destroy compute inventory | Collected |
| Post-destroy network load balancer inventory | Collected |
| Secret scan | Passed |
| Public repository safety | No Terraform state, kubeconfig, key, token, or private runtime artifact committed |

## Expected scanner behavior

The cloud-run recorded non-zero return codes from Trivy and kube-score during before/after scanning. This is expected for security validation tooling when findings, warnings, or scoring failures are present. The outputs are retained as evidence rather than treated as cloud-run infrastructure failures.

## Evidence locations

| Evidence group | Location |
|---|---|
| Phase command output | evidence/command-outputs/YCSEC_13_0_OUTPUT_managed_kubernetes_baseline_remediation_cloud_run.txt |
| Terraform apply evidence | evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_apply_sanitized.txt |
| Terraform destroy evidence | evidence/command-outputs/YCSEC_13_0_OUTPUT_mks_terraform_destroy_sanitized.txt |
| Node readiness | evidence/before/yc_mks_nodes_ready.txt |
| Baseline evidence | evidence/before/ |
| Remediation evidence | evidence/after/ |
| Post-destroy cluster check | evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_mks_cluster_list.txt |
| Post-destroy compute check | evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_compute_instance_list.txt |
| Post-destroy load balancer check | evidence/command-outputs/YCSEC_13_0_OUTPUT_post_destroy_nlb_list.txt |

## Claim now supported

The project now supports the claim that Kubernetes baseline and remediation controls were validated in a real Yandex Managed Kubernetes environment with sanitized evidence and controlled resource cleanup.
