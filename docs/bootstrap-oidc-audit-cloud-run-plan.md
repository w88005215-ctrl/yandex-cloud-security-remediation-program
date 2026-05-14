# Bootstrap/OIDC/Audit Cloud-Run Plan

## Purpose

This document defines the first controlled roadmap cloud-run after roadmap reconciliation.

The goal is to close the bootstrap, IAM, OIDC/WIF, audit/logging, registry and storage evidence gaps before performing the full Managed Kubernetes baseline/remediation cloud-run.

This is a planning document only. No cloud resources are created in this phase.

---

## Cloud-Run Objective

The bootstrap cloud-run must prove that the project can create and validate the identity, audit and supporting cloud foundation required for later Kubernetes remediation evidence.

The run must demonstrate:

- scoped service accounts;
- least-privilege IAM role assignment;
- Workload Identity Federation / OIDC pattern for GitHub Actions;
- audit/logging path;
- Container Registry availability or documented controlled alternative;
- Object Storage / evidence storage availability or documented controlled alternative;
- evidence collection and sanitization;
- cleanup or retention decision.

---

## Evidence Gaps Targeted

| Gap ID | Area | Closure Target |
|---|---|---|
| GAP-CLOUD-001 | Bootstrap | Dedicated bootstrap cloud-run evidence |
| GAP-IAM-001 | IAM | Service accounts and scoped role evidence |
| GAP-OIDC-001 | OIDC/WIF | GitHub Actions short-lived cloud auth evidence |
| GAP-AUD-001 | Audit Trails | Redacted audit/logging evidence |
| GAP-REG-001 | Container Registry | Registry creation and access evidence |
| GAP-PUB-001 | Publication safety | Redaction and safety process for cloud bootstrap evidence |

---

## Expected Cloud Resources

The bootstrap run may create only the minimum resources required for evidence.

| Resource Type | Purpose | Retention Decision |
|---|---|---|
| Service account: Terraform/bootstrap | Infrastructure deployment boundary | Destroy unless needed for next phase |
| Service account: GitHub Actions/OIDC | Short-lived CI/CD cloud access | Keep only if low-cost and required |
| Service account: audit/evidence | Audit/evidence read or write boundary | Keep only if required |
| IAM role bindings | Least-privilege proof | Remove if service accounts are removed |
| Workload Identity Federation / OIDC binding | CI/CD without static keys | Keep only if required for next phase |
| Container Registry | Image storage/pull evidence | Destroy unless needed |
| Object Storage bucket | Audit/evidence or Terraform backend pattern | Destroy unless needed |
| Audit Trails / logging target | Audit event collection | Keep only if low-cost and required |
| Cloud Logging group | Audit/log delivery target if used | Destroy unless required |

---

## Out of Scope

The bootstrap cloud-run must not create:

- Managed Kubernetes cluster;
- compute instances;
- load balancers;
- managed databases;
- GPU resources;
- Marketplace resources;
- long-running workloads;
- unnecessary public endpoints.

---

## Pre-Run Requirements

Before the cloud-run:

1. Billing budget and notifications must be verified.
2. Target folder and cloud must be verified.
3. Terraform plan must be saved.
4. Expected resources must be listed.
5. Cleanup strategy must be documented.
6. Evidence output paths must exist.
7. Secret scan must pass.
8. No Terraform state, kubeconfig or token-like files may be present in the repository.
9. Public evidence sanitization strategy must be defined.

---

## Planned Command Evidence

The next cloud-run should collect:

| Evidence File | Purpose |
|---|---|
| evidence/command-outputs/YCSEC_12_8_OUTPUT_bootstrap_cloud_run.txt | Raw controlled run output before sanitization decision |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_bootstrap_cloud_run_sanitized.txt | Public-safe output |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_bootstrap_resource_inventory.txt | Resource inventory after apply and cleanup |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_oidc_validation_redacted.txt | OIDC/WIF validation evidence |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_audit_events_redacted.txt | Redacted audit/logging evidence |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_final_git_control.txt | Final git/evidence control |

---

## Success Criteria

The bootstrap cloud-run is successful only if:

- Terraform plan matches expected bootstrap resources.
- IAM/service account resources are created or validated.
- OIDC/WIF flow is proven or a provider limitation is documented.
- Audit/logging path is proven or a provider limitation is documented.
- Registry/storage resources are proven or a controlled alternative is documented.
- No long-lived secret is committed.
- Public evidence is sanitized.
- Cost boundary is respected.
- Resource retention or cleanup is explicitly documented.
- Git milestone is committed and tagged.

---

## Failure Criteria

The run must stop or be marked failed if:

- unexpected paid resources appear in the Terraform plan;
- static cloud keys are introduced into the repository;
- Terraform state is written into the repository;
- kubeconfig or token-like files are detected;
- audit/logging evidence contains sensitive unredacted fields;
- cleanup cannot be verified;
- gitleaks detects secrets;
- cloud resources remain without documented retention decision.

---

## Next Phase

If this plan passes, the next phase is:

Phase 12.8 — Bootstrap Cloud-Run: IAM, OIDC/WIF, audit/logging, registry/storage, evidence and cleanup.
