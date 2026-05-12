# Evidence Index

## Purpose

This document maps project evidence to implemented controls, remediation outcomes and audit artifacts.

The project follows an evidence-first model. Every important phase must produce command output, screenshots, scan reports, before/after findings or sanitized audit logs.

## Evidence storage model

| Evidence Type | Location | Public | Notes |
|---|---|---:|---|
| Command outputs | evidence/command-outputs/ | Yes | Must not contain secrets |
| Screenshots | evidence/screenshots/ | Yes, after review | Must be manually redacted |
| Before-state findings | evidence/before/ | Yes, after review | Used to prove insecure baseline |
| After-state findings | evidence/after/ | Yes, after review | Used to prove remediation |
| Sanitized audit artifacts | evidence/sanitized/ | Yes | Raw logs must not be committed |
| Before/after metrics | evidence/before-after-metrics.md | Yes | Main remediation outcome table |

## Evidence ID convention

| Prefix | Area |
|---|---|
| EVID-LOCAL | Local workstation and repository setup |
| EVID-COST | Cost control and budget discipline |
| EVID-PUB | Publication safety |
| EVID-IAC | Terraform / IaC |
| EVID-IAM | IAM and least privilege |
| EVID-OIDC | GitHub Actions OIDC / Workload Identity Federation |
| EVID-SAML | SAML/SSO federation pattern |
| EVID-K8S | Kubernetes baseline and hardening |
| EVID-NET | NetworkPolicy and network isolation |
| EVID-IMG | Image scanning, SBOM and vulnerabilities |
| EVID-AUD | Audit Trails and audit evidence |
| EVID-CTRL | Control matrix and governance |

## Current evidence inventory

| Evidence ID | Phase | File | Description | Sanitized | Public |
|---|---|---|---|---:|---:|
| EVID-LOCAL-001 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_repository_skeleton_control.txt | Repository skeleton validation | Yes | Yes |
| EVID-LOCAL-002 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_first_commit_precheck.txt | First commit precheck | Yes | Yes |
| EVID-LOCAL-003 | Phase 1 | evidence/command-outputs/YCSEC_01_OUTPUT_first_commit_result.txt | First commit result | Yes | Yes |
| EVID-DOC-001 | Phase 2 | evidence/command-outputs/YCSEC_02_OUTPUT_root_portfolio_files_control.txt | Root portfolio documentation control | Yes | Yes |
| EVID-DOC-002 | Phase 2 | evidence/command-outputs/YCSEC_02_OUTPUT_final_git_control.txt | Phase 2 final git control | Yes | Yes |
| EVID-COST-001 | Phase 3 | docs/cost-control.md | Cost-control model | Yes | Yes |
| EVID-COST-002 | Phase 3 | docs/resource-inventory.md | Resource inventory model | Yes | Yes |
| EVID-PUB-001 | Phase 3 | docs/publication-safety-checklist.md | Publication safety checklist | Yes | Yes |
| EVID-LOCAL-004 | Phase 3 | evidence/command-outputs/YCSEC_03_OUTPUT_tool_versions.txt | Local tool version inventory | Yes | Yes |

## Evidence quality rules

Evidence must answer:

- what was executed;
- where it was executed;
- when it was executed;
- what changed;
- what control it supports;
- whether it is safe to publish.

## Redaction rules

Before public release, redact or remove:

- tokens;
- keys;
- service account credentials;
- kubeconfig content;
- Terraform state;
- raw audit logs;
- billing data;
- personal data;
- payment data;
- sensitive account identifiers where not required.

## Reviewer note

Evidence in this project is intentionally structured so a reviewer can trace the path:

architecture -> implementation -> scan result -> remediation -> audit evidence -> control matrix -> final report.
