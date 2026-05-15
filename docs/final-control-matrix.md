# Final Control Matrix

Generated: `2026-05-14T17:02:24.710374+00:00`

This matrix maps the implemented Yandex Cloud Security Remediation Program controls to committed evidence, validation status, portfolio-safe claims, and common security framework language.

## Executive Summary

- Control matrix status: **validated**.
- Evidence source: committed repository documentation, command outputs, SBOMs, vulnerability scans, admission-control evidence, and final remediation metrics.
- Cloud scope: Yandex Cloud IAM/OIDC, Audit Trails, Container Registry, Object Storage evidence handling, Managed Kubernetes, Terraform, and Kyverno.
- Temporary paid resources: Managed Kubernetes runtime resources were destroyed after validation.
- Retained resources: bootstrap registry, audit trail, evidence bucket, bootstrap service accounts, and federation were retained only for evidence validation and later removed during the retained bootstrap cleanup phase.

## Control Matrix

| Control ID | Domain | Control Objective | Status | Evidence | Portfolio-Safe Claim | Framework Mapping |
|---|---|---|---|---|---|---|
| YCSEC-IAM-01 | Identity and Federation | Replace long-lived cloud keys with GitHub Actions OIDC federation and short-lived token exchange. | **Validated** | `docs/github-actions-oidc-validation.md`<br>`evidence/command-outputs/YCSEC_12_8D_OUTPUT_github_actions_oidc_validation_success.txt` | OIDC-based CI/CD authentication was validated without long-lived cloud key material. | NIST SSDF PW.6<br>SLSA Build L2/L3 pattern<br>CIS IAM least privilege principle |
| YCSEC-IAM-02 | Identity and Access Management | Use scoped service accounts for bootstrap, registry, audit, and short-lived Managed Kubernetes workloads. | **Validated** | `docs/cloud-evidence-gap-register.md`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt` | Temporary runtime identities were separated from bootstrap identities; retained bootstrap resources were later removed after evidence validation. | CIS IAM least privilege<br>NIST CSF 2.0 PR.AA |
| YCSEC-AUD-01 | Audit and Evidence | Enable audit trail collection and preserve sanitized public evidence for cloud actions. | **Validated** | `docs/cloud-evidence-gap-register.md`<br>`docs/evidence-index.md` | Cloud audit evidence was integrated into the evidence register and gap register. | NIST CSF 2.0 DE.CM<br>ISO 27001 logging/audit control pattern |
| YCSEC-IAC-01 | Infrastructure as Code | Provision and destroy cloud infrastructure through controlled Terraform runs. | **Validated** | `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_plan_sanitized.txt`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_apply_sanitized.txt`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt` | Cloud resources were created and destroyed through IaC with post-destroy verification. | NIST SSDF PO.5<br>CIS IaC governance pattern |
| YCSEC-K8S-01 | Managed Kubernetes | Demonstrate real Managed Kubernetes lifecycle evidence in Yandex Cloud. | **Validated** | `docs/managed-kubernetes-cloud-run-plan.md`<br>`docs/kyverno-admission-policy-enforcement-validation.md`<br>`evidence/after/kyverno_mks_nodes_ready.txt` | Managed Kubernetes was validated using real cloud infrastructure, not only local manifests. | CIS Kubernetes<br>NIST CSF 2.0 PR.PS |
| YCSEC-K8S-02 | Kubernetes Workload Hardening | Move from insecure workload patterns to hardened runtime controls. | **Validated** | `kubernetes/admission-validation/hardened-workload-allowed.yaml`<br>`evidence/after/kyverno_hardened_workload_allowed.txt` | Hardened workload controls were validated through server-side admission. | CIS Kubernetes Pod Security<br>NSA/CISA Kubernetes Hardening pattern |
| YCSEC-K8S-03 | Policy as Code | Enforce workload security requirements at admission time. | **Validated** | `kubernetes/admission-validation/kyverno-supply-chain-policy.yaml`<br>`evidence/after/kyverno_policy_status.txt`<br>`evidence/after/kyverno_insecure_workload_denied.txt`<br>`evidence/after/kyverno_hardened_workload_allowed.txt` | Kyverno admission policy enforcement was proven on Yandex Managed Kubernetes. | CIS Kubernetes Admission Control<br>NIST SSDF PW.8 |
| YCSEC-SC-01 | Supply Chain Security | Build and push container images through OIDC-authenticated CI/CD into Yandex Container Registry. | **Validated** | `docs/supply-chain-oidc-registry-validation.md`<br>`evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation_success.txt` | CI/CD image publishing was validated through OIDC and Yandex Container Registry. | SLSA build provenance pattern<br>NIST SSDF PS.3 |
| YCSEC-SC-02 | SBOM | Generate SBOM evidence for insecure and hardened container images. | **Validated** | `docs/sbom-vulnerability-validation.md`<br>`evidence/sbom/ycsec_supply_chain_insecure_sbom_cyclonedx.json`<br>`evidence/sbom/ycsec_supply_chain_hardened_sbom_cyclonedx.json` | SBOM evidence exists for both vulnerable baseline and hardened image. | NIST SSDF PS.3<br>SLSA dependency visibility |
| YCSEC-SC-03 | Vulnerability Management | Measure vulnerability reduction between insecure and hardened images. | **Validated** | `docs/supply-chain-vulnerability-metrics.md`<br>`docs/final-remediation-metrics.md`<br>`evidence/metrics/final_remediation_metrics.json` | The hardened image showed measurable vulnerability reduction compared with the insecure baseline. | NIST SSDF RV.1<br>NIST CSF 2.0 ID.RA |
| YCSEC-OPS-01 | Evidence Hygiene | Keep public evidence sanitized and prevent accidental publication of secrets, kubeconfigs, or Terraform state. | **Validated** | `.gitleaks.toml`<br>`docs/generated-evidence-gitleaks-handling.md`<br>`docs/evidence-index.md` | Evidence publication controls were implemented and validated before commits. | NIST CSF 2.0 PR.DS<br>Secure evidence handling pattern |
| YCSEC-OPS-02 | Cost and Cleanup Control | Avoid uncontrolled paid cloud resource retention after validation runs. | **Validated** | `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt`<br>`evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt`<br>`docs/cloud-evidence-gap-register.md` | Temporary paid MKS resources were removed and verified after the cloud evidence run. | Cloud cost governance<br>Operational resilience |
| YCSEC-GOV-01 | Governance and Portfolio Claims | Keep public claims aligned with validated evidence and avoid overstating unproven capabilities. | **Validated** | `docs/cloud-evidence-gap-register.md`<br>`docs/evidence-index.md`<br>`docs/final-remediation-metrics.md` | Validated claims are tied to committed evidence paths. | Audit readiness<br>Security governance |

## Control Coverage Summary

- **Audit and Evidence**: 1 control(s)
- **Cost and Cleanup Control**: 1 control(s)
- **Evidence Hygiene**: 1 control(s)
- **Governance and Portfolio Claims**: 1 control(s)
- **Identity and Access Management**: 1 control(s)
- **Identity and Federation**: 1 control(s)
- **Infrastructure as Code**: 1 control(s)
- **Kubernetes Workload Hardening**: 1 control(s)
- **Managed Kubernetes**: 1 control(s)
- **Policy as Code**: 1 control(s)
- **SBOM**: 1 control(s)
- **Supply Chain Security**: 1 control(s)
- **Vulnerability Management**: 1 control(s)

## Publication Boundary

The final portfolio may claim validated implementation of IAM/OIDC federation, Terraform-controlled cloud lifecycle, Managed Kubernetes hardening, Kyverno admission control, registry-backed supply-chain validation, SBOM generation, vulnerability reduction, evidence hygiene, and cleanup verification.

The final portfolio should not claim continuous production operation, enterprise-scale traffic volume, multi-region high availability, or external compliance certification unless those are validated in later evidence.
