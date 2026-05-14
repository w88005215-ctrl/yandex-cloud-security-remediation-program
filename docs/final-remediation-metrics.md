# Final Remediation Metrics

## Purpose

This document consolidates the final measurable outcomes of the Yandex Cloud Security Remediation Program.

The project demonstrates a full cloud security remediation lifecycle:

Terraform/IaC -> IAM/OIDC -> Audit evidence -> Managed Kubernetes baseline -> Remediation -> Registry/SBOM/Vulnerability validation -> Admission policy enforcement -> Cleanup evidence

## Final validated outcomes

| Domain | Initial risk / baseline | Remediated state | Evidence status |
|---|---|---|---|
| Cloud IAM / CI identity | CI/CD workflows may depend on long-lived cloud credentials. | GitHub Actions OIDC token exchange validates Yandex Cloud access without static cloud keys in the repository. | Validated |
| Auditability | Cloud actions need independent audit evidence. | Audit Trails and evidence storage were validated as retained bootstrap controls. | Validated |
| Managed Kubernetes security | Baseline Kubernetes posture allowed insecure workload patterns. | Managed Kubernetes remediation workflow was executed with short-lived infrastructure and cleanup evidence. | Validated |
| Container registry / supply chain | Images require registry-backed traceability and vulnerability evidence. | Yandex Container Registry image push, SBOM generation, and vulnerability comparison were validated. | Validated |
| Vulnerability reduction | Controlled vulnerable image baseline produced findings. | Hardened image produced measurable vulnerability reduction. | Validated |
| Admission policy enforcement | Insecure workload admission needed runtime enforcement evidence. | Kyverno denied the insecure workload and allowed the hardened workload on real Yandex Managed Kubernetes. | Validated |
| Cleanup discipline | Temporary paid resources may remain after testing. | Managed Kubernetes cluster, node group, compute, network, subnet, NLB, and temporary service accounts were verified as removed. | Validated |

## Primary evidence references

| Evidence area | Reference |
|---|---|
| GitHub Actions OIDC validation | v0.12.8d-github-actions-oidc-validation |
| Audit Trails validation | v0.12.8e-audit-trails-evidence-validation |
| Registry and evidence storage validation | v0.12.8f-registry-evidence-storage-validation |
| Managed Kubernetes baseline/remediation cloud-run | v0.13.0-managed-kubernetes-baseline-remediation-cloud-run |
| Supply-chain registry OIDC push | v0.13.3-supply-chain-oidc-registry-validation |
| SBOM and vulnerability validation | v0.13.4-sbom-vulnerability-validation |
| Kyverno admission enforcement | v0.13.5-kyverno-admission-policy-enforcement |

## Runtime enforcement proof

Phase 13.5 provides the strongest runtime control evidence:

- A short-lived Yandex Managed Kubernetes cluster was created.
- Kyverno admission controller was installed.
- The insecure workload was denied by Kyverno-specific admission policy evidence.
- The hardened workload passed server-side admission validation.
- Terraform destroy completed.
- Post-destroy cloud checks confirmed no temporary MKS resources remained.

Evidence files:

- evidence/after/kyverno_mks_nodes_ready.txt
- evidence/after/kyverno_install_apply.txt
- evidence/after/kyverno_controller_pods_ready.txt
- evidence/after/kyverno_policy_apply.txt
- evidence/after/kyverno_policy_status.txt
- evidence/after/kyverno_insecure_workload_denied.txt
- evidence/after/kyverno_hardened_workload_allowed.txt
- evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt

## Supply-chain proof

Phase 13.3 and Phase 13.4 prove the supply-chain security path:

- GitHub Actions exchanged OIDC identity for a Yandex Cloud IAM token.
- Controlled insecure and hardened images were pushed to Yandex Container Registry.
- SBOMs were generated with Syft.
- Vulnerability scans were generated with Trivy and Grype.
- The hardened image showed measurable vulnerability reduction.

Evidence files:

- evidence/sbom/ycsec_supply_chain_insecure_sbom_cyclonedx.json
- evidence/sbom/ycsec_supply_chain_hardened_sbom_cyclonedx.json
- evidence/vulnerability/trivy_insecure_image.json
- evidence/vulnerability/trivy_hardened_image.json
- evidence/vulnerability/grype_insecure_image.json
- evidence/vulnerability/grype_hardened_image.json
- evidence/metrics/supply_chain_vulnerability_metrics.json
- evidence/metrics/final_remediation_metrics.json

## Final project status after this phase

The core technical evidence track is complete.

Remaining work is packaging and governance documentation:

1. Final control matrix.
2. Final risk register.
3. AWS/GCP/Azure control mapping.
4. README publication refresh.
5. Retained bootstrap resource cleanup decision.
6. Final RU/EN portfolio report.
