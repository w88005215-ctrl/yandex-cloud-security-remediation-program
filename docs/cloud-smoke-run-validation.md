# Yandex Cloud Managed Kubernetes Smoke-Run Validation

## Scope

This document summarizes the successful short-lived Yandex Cloud Managed Kubernetes smoke-run performed as part of the Yandex Cloud Security Remediation Program.

The objective was to validate real managed cloud provisioning through Terraform, runtime provider authentication, Kubernetes API access, worker node readiness, mandatory cleanup, zero-resource verification and publication-safe evidence handling.

---

## Validation Objectives

| Objective | Result |
|---|---|
| Terraform provider authentication | Passed |
| Terraform initialization | Passed |
| Terraform validation | Passed |
| Terraform plan generation | Passed |
| Temporary managed cloud provisioning | Passed |
| Managed Kubernetes API reachability | Passed |
| Worker node readiness | Passed |
| Repository secret scan | Passed |
| Mandatory Terraform destroy | Passed |
| Post-destroy zero-resource verification | Passed |
| Publication-safe evidence handling | Passed |

---

## Temporary Cloud Resources

| Resource Type | Count | Purpose |
|---|---:|---|
| VPC network | 1 | Isolated smoke-run network boundary |
| Subnet | 1 | Zonal subnet for Managed Kubernetes |
| Service accounts | 2 | Separate cluster and node identities |
| IAM role bindings | 3 | Required smoke-run IAM permissions |
| Managed Kubernetes cluster | 1 | Real managed Kubernetes control plane validation |
| Managed Kubernetes node group | 1 | Worker node readiness validation |

All temporary resources were destroyed during the same smoke-run.

---

## Validated Controls

| Control Area | Validation Result |
|---|---|
| Runtime cloud authentication | Terraform consumed runtime Yandex Cloud authentication values |
| Static cloud key avoidance | No service account key was committed |
| Runtime artifact isolation | Terraform runtime directory was kept outside the repository |
| Kubeconfig isolation | Temporary kubeconfig was kept outside the repository |
| Secret scanning | Gitleaks completed with no leaks detected |
| Cleanup discipline | Terraform destroy removed all temporary resources |
| Inventory verification | Post-destroy checks confirmed no remaining smoke resources |
| Evidence sanitization | Public evidence was redacted before commit |

---

## Warning Classification

The smoke-run reported a controlled default-zone fallback to ru-central1-a.

The warning was accepted because it did not indicate authentication failure, Terraform failure, resource leakage, cleanup failure, cost-control failure or Kubernetes runtime failure.

---

## Evidence References

| Evidence ID | File | Description |
|---|---|---|
| EVID-YC-SMOKE-001 | evidence/command-outputs/YCSEC_11_2_OUTPUT_hardened_smoke_run_success_sanitized.txt | Sanitized successful smoke-run output |
| EVID-YC-SMOKE-002 | evidence/command-outputs/YCSEC_11_2_OUTPUT_smoke_run_success_closeout.txt | Final smoke-run closeout and zero-resource verification |

---

## Result

Phase 11.2 confirmed a complete short-lived real-cloud lifecycle:

Terraform authentication -> plan -> apply -> Kubernetes validation -> secret scan -> destroy -> zero-resource verification -> sanitized evidence.

This validates the cloud execution foundation required for the managed Kubernetes baseline and remediation stages.
