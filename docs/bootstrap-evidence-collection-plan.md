# Bootstrap Evidence Collection Plan

## Purpose

This document defines the evidence that must be captured during the bootstrap/OIDC/audit cloud-run.

---

## Evidence Categories

| Category | Evidence | Public Handling |
|---|---|---|
| Terraform | init, validate, plan, apply output | Redact IDs if needed |
| IAM | service account list, role binding summary | Redact IDs if needed |
| OIDC/WIF | federation/trust validation, token exchange proof | Redact token, claims, IDs |
| Audit/logging | audit/log events for bootstrap operations | Redact actor IDs, resource IDs, timestamps if needed |
| Registry | registry list/access evidence | Redact registry IDs if needed |
| Object Storage | bucket/storage evidence | Redact bucket names if sensitive |
| Cleanup | destroy or retention inventory | Public-safe summary |
| Secret safety | gitleaks output and file checks | Public-safe |

---

## Required Public Evidence Files

| File | Description |
|---|---|
| evidence/command-outputs/YCSEC_12_8_OUTPUT_bootstrap_cloud_run_sanitized.txt | Sanitized bootstrap cloud-run output |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_bootstrap_resource_inventory.txt | Public-safe resource inventory |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_oidc_validation_redacted.txt | Redacted OIDC/WIF validation evidence |
| evidence/command-outputs/YCSEC_12_8_OUTPUT_audit_events_redacted.txt | Redacted audit/logging evidence |
| docs/bootstrap-cloud-run-results.md | Human-readable result summary |
| docs/resource-inventory.md | Updated resource inventory |
| docs/evidence-index.md | Evidence index update |

---

## Sensitive Data That Must Not Be Published

The following must not be published unredacted:

- IAM tokens;
- OAuth tokens;
- federation credentials;
- full JWT claims;
- private keys;
- service account authorized keys;
- kubeconfig;
- Terraform state;
- exact sensitive account identifiers if not required for review;
- billing/account details;
- personal account metadata;
- raw audit logs containing sensitive fields.

---

## Evidence Quality Standard

Evidence must show the security claim without exposing unnecessary account-specific details.

For each claim, evidence should answer:

1. What was done?
2. What command or artifact proves it?
3. What security control does it support?
4. Was it cleaned up or intentionally retained?
5. Is it safe for public repository publication?
