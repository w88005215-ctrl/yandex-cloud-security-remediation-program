# Final Risk Register

This document consolidates the final project risk register for the Yandex Cloud Security Remediation Program.

The register is evidence-bound: each risk is tied to validated controls, repository documentation, sanitized command evidence, and final remediation metrics. It does not claim production certification; it demonstrates a controlled security engineering remediation case with verified cloud evidence.

## Summary

- Total risks tracked: **8**
- Generated: `2026-05-14T17:15:25.663673+00:00`
- Cloud resources created by this phase: **No**
- Publication boundary: claims must remain limited to committed controls and sanitized evidence.

## Residual Risk Distribution

| Residual risk | Count |
|---|---:|
| Low | 5 |
| Medium | 3 |

## Risk Register

| Risk ID | Domain | Risk | Baseline exposure | Residual risk | Status | Owner |
|---|---|---|---|---|---|---|
| YCSEC-RISK-01 | IAM / Federation | Long-lived cloud credentials in CI/CD or operator workflows | High | Low | Mitigated | Cloud Security / DevSecOps |
| YCSEC-RISK-02 | Audit / Governance | Insufficient cloud audit evidence for security-relevant actions | High | Medium | Mitigated with retained residual monitoring requirement | Cloud Security / Governance |
| YCSEC-RISK-03 | Infrastructure as Code | Uncontrolled cloud resource creation and cost drift | High | Low | Mitigated | Cloud Engineering |
| YCSEC-RISK-04 | Managed Kubernetes | Insecure workloads admitted into the cluster | High | Low | Mitigated | Platform Security |
| YCSEC-RISK-05 | Supply Chain Security | Unvalidated image provenance and registry push path | High | Medium | Mitigated with future signing/attestation enhancement | DevSecOps / Supply Chain Security |
| YCSEC-RISK-06 | Vulnerability Management | Known vulnerabilities remain unmeasured across baseline and hardened artifacts | High | Medium | Mitigated with residual dependency lifecycle tracking | DevSecOps / AppSec |
| YCSEC-RISK-07 | Evidence Handling | Sensitive artifacts accidentally committed to public repository | High | Low | Mitigated | Security Engineering |
| YCSEC-RISK-08 | Publication Boundary | Portfolio claims exceed validated evidence | Medium | Low | Mitigated | Project Owner / Security Governance |

## Detailed Risk Treatment

### YCSEC-RISK-01 — IAM / Federation

**Risk:** Long-lived cloud credentials in CI/CD or operator workflows

**Business impact:** Credential leakage could allow unauthorized cloud access, registry access, or infrastructure modification.

**Baseline exposure:** High

**Current residual risk:** Low

**Treatment:** Mitigated through GitHub Actions OIDC token exchange, short-lived IAM tokens, and repository secret scanning.

**Status:** Mitigated

**Validated controls:**

- `YCSEC-IAM-01`
- `YCSEC-IAM-02`
- `YCSEC-SC-02`

**Evidence:**

- `docs/github-actions-oidc-validation.md`
- `docs/supply-chain-oidc-registry-validation.md`
- `evidence/command-outputs/YCSEC_12_8D_OUTPUT_github_actions_oidc_validation_success.txt`
- `evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation_success.txt`

### YCSEC-RISK-02 — Audit / Governance

**Risk:** Insufficient cloud audit evidence for security-relevant actions

**Business impact:** Weak auditability would reduce incident reconstruction, accountability, and compliance confidence.

**Baseline exposure:** High

**Current residual risk:** Medium

**Treatment:** Mitigated through retained Audit Trails, evidence index discipline, and explicit cloud evidence gap tracking.

**Status:** Mitigated with retained residual monitoring requirement

**Validated controls:**

- `YCSEC-AUD-01`
- `YCSEC-GOV-01`

**Evidence:**

- `docs/audit-trails-evidence-validation.md`
- `docs/cloud-evidence-gap-register.md`
- `docs/evidence-index.md`

### YCSEC-RISK-03 — Infrastructure as Code

**Risk:** Uncontrolled cloud resource creation and cost drift

**Business impact:** Unexpected managed infrastructure could consume budget and leave exposed resources behind.

**Baseline exposure:** High

**Current residual risk:** Low

**Treatment:** Mitigated through short-lived cloud runs, Terraform destroy evidence, and post-destroy zero-resource verification.

**Status:** Mitigated

**Validated controls:**

- `YCSEC-IAC-01`
- `YCSEC-OPS-01`
- `YCSEC-OPS-02`

**Evidence:**

- `docs/managed-kubernetes-destroy-and-retention-plan.md`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_mks_terraform_destroy_sanitized.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_mks_cluster_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_compute_instance_list.txt`
- `evidence/command-outputs/YCSEC_13_5_OUTPUT_post_destroy_nlb_list.txt`

### YCSEC-RISK-04 — Managed Kubernetes

**Risk:** Insecure workloads admitted into the cluster

**Business impact:** Privileged, root, mutable-image, or weakly constrained workloads could increase cluster compromise impact.

**Baseline exposure:** High

**Current residual risk:** Low

**Treatment:** Mitigated through Kyverno admission policy enforcement and explicit deny/allow evidence on Managed Kubernetes.

**Status:** Mitigated

**Validated controls:**

- `YCSEC-K8S-01`
- `YCSEC-K8S-02`
- `YCSEC-K8S-03`
- `YCSEC-K8S-04`

**Evidence:**

- `docs/kyverno-admission-policy-enforcement-validation.md`
- `docs/kyverno-admission-policy-enforcement-metrics.md`
- `evidence/after/kyverno_insecure_workload_denied.txt`
- `evidence/after/kyverno_hardened_workload_allowed.txt`
- `evidence/sanitized/kyverno_admission_policy_enforcement_redacted.txt`

### YCSEC-RISK-05 — Supply Chain Security

**Risk:** Unvalidated image provenance and registry push path

**Business impact:** Untrusted images could enter the runtime path without adequate identity, registry, or policy validation.

**Baseline exposure:** High

**Current residual risk:** Medium

**Treatment:** Mitigated through OIDC-based registry push, SBOM generation, vulnerability scanning, and admission policy requiring Yandex Container Registry images.

**Status:** Mitigated with future signing/attestation enhancement

**Validated controls:**

- `YCSEC-SC-01`
- `YCSEC-SC-02`
- `YCSEC-SC-03`

**Evidence:**

- `docs/supply-chain-oidc-registry-validation.md`
- `docs/sbom-vulnerability-validation.md`
- `docs/supply-chain-vulnerability-metrics.md`
- `evidence/metrics/supply_chain_vulnerability_metrics.json`

### YCSEC-RISK-06 — Vulnerability Management

**Risk:** Known vulnerabilities remain unmeasured across baseline and hardened artifacts

**Business impact:** Unmeasured vulnerable dependencies or packages could persist without remediation evidence.

**Baseline exposure:** High

**Current residual risk:** Medium

**Treatment:** Mitigated through SBOM, Trivy/Grype scanning, and measurable before/after vulnerability reduction.

**Status:** Mitigated with residual dependency lifecycle tracking

**Validated controls:**

- `YCSEC-SC-03`
- `YCSEC-GOV-01`

**Evidence:**

- `docs/sbom-vulnerability-validation.md`
- `docs/supply-chain-vulnerability-metrics.md`
- `docs/final-remediation-metrics.md`
- `evidence/vulnerability/trivy_insecure_image.txt`
- `evidence/vulnerability/trivy_hardened_image.txt`
- `evidence/vulnerability/grype_insecure_image.txt`
- `evidence/vulnerability/grype_hardened_image.txt`

### YCSEC-RISK-07 — Evidence Handling

**Risk:** Sensitive artifacts accidentally committed to public repository

**Business impact:** Public leakage of state, kubeconfig, keys, or tokens could compromise infrastructure or invalidate publication safety.

**Baseline exposure:** High

**Current residual risk:** Low

**Treatment:** Mitigated through sanitized evidence, private runtime storage, gitleaks scanning, and explicit forbidden-artifact checks.

**Status:** Mitigated

**Validated controls:**

- `YCSEC-OPS-02`
- `YCSEC-GOV-01`

**Evidence:**

- `docs/generated-evidence-gitleaks-handling.md`
- `docs/evidence-index.md`
- `evidence/command-outputs/YCSEC_13_4A_OUTPUT_gitleaks_generated_evidence_handling.txt`
- `<curated-publication-noise-artifact>`

### YCSEC-RISK-08 — Publication Boundary

**Risk:** Portfolio claims exceed validated evidence

**Business impact:** Overstated claims would reduce credibility under technical review.

**Baseline exposure:** Medium

**Current residual risk:** Low

**Treatment:** Mitigated through evidence-bound claims, control matrix, risk register, and explicit publication boundaries.

**Status:** Mitigated

**Validated controls:**

- `YCSEC-GOV-01`

**Evidence:**

- `docs/cloud-evidence-gap-register.md`
- `docs/final-control-matrix.md`
- `docs/final-remediation-metrics.md`

## Publication Boundary

This risk register supports portfolio publication only within the validated evidence boundary. The repository demonstrates controlled cloud security remediation, IAM/OIDC validation, supply-chain evidence, Managed Kubernetes admission enforcement, SBOM/vulnerability metrics, cleanup verification, and governance artifacts. It should not be represented as a production certification, managed service audit, or third-party compliance attestation.
