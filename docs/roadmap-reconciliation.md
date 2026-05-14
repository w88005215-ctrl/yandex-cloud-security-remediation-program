# Roadmap Reconciliation

## Purpose

This document reconciles the current repository state with the intended roadmap of the Yandex Cloud Security Remediation Program.

The project is not a simple Kubernetes laboratory. The intended outcome is a portfolio-grade cloud security and DevSecOps remediation case covering Terraform/IaC, IAM, GitHub Actions OIDC/Workload Identity Federation, SAML/SSO federation pattern, Managed Kubernetes hardening, policy-as-code, audit evidence, before/after remediation metrics, risk register, control matrix and safe publication.

---

## Current Confirmed Milestone

Current confirmed milestone:

`v0.12.5-kubernetes-remediation-case-study`

Current confirmed commit:

`29f2613`

Current stage:

After Kubernetes remediation static/local packaging and before the full roadmap cloud evidence runs.

---

## Important Correction

The Kubernetes remediation track is complete as a static/local portfolio package.

The overall project is not complete.

The repository must not be treated as final release-ready until the missing cloud evidence tracks are closed.

---

## What Has Been Proven

| Area | Evidence Status | Notes |
|---|---|---|
| Repository structure and evidence discipline | Proven | Project structure, evidence index and command outputs exist |
| Cost-control discipline | Partially proven | Short-lived cloud run model and cleanup discipline exist |
| Terraform skeleton and local validation | Proven | Terraform/IaC structure and validation gates exist |
| Yandex Cloud readiness | Proven | Readiness checks were completed before cloud execution |
| Managed Kubernetes lifecycle smoke-run | Proven | Temporary cluster creation, kubectl access, Ready node and destroy were validated |
| Smoke-run cleanup | Proven | Post-destroy zero-resource checks passed |
| Public evidence sanitization | Proven | Smoke-run output was sanitized and integrated |
| Kubernetes remediation readiness | Proven locally | Readiness inventory exists |
| Kubernetes baseline validation plan | Proven locally | Baseline plan and control matrix exist |
| Kubernetes baseline static validation | Proven locally | Baseline findings and validator exist |
| Kubernetes remediation control package | Proven locally | Remediation manifests, RBAC, NetworkPolicy and Kyverno package exist |
| Kubernetes before/after comparison | Proven locally | Static comparison and metrics exist |
| Kubernetes remediation case study | Proven locally | Portfolio case study exists |

---

## What Has Not Yet Been Proven

| Roadmap Area | Current Status | Required Next Evidence |
|---|---|---|
| Bootstrap cloud-run | Not fully closed | IAM, service accounts, registry, object storage and audit/logging cloud evidence |
| GitHub Actions OIDC/WIF | Not fully closed | Short-lived token flow without static cloud keys |
| SAML/SSO federation pattern | Not fully closed | Federation design and evidence-safe implementation or validated pattern |
| Local runtime Kubernetes baseline/remediation | Not fully confirmed | kind/k3d runtime apply/scan evidence if not already present |
| Managed Kubernetes insecure baseline cloud-run | Not done | Real cluster before-state evidence |
| Managed Kubernetes remediation cloud-run | Not done | Real cluster after-state evidence |
| Audit Trails evidence | Not closed | IAM/Kubernetes/registry/audit events exported and redacted |
| Final measurable remediation outcomes | Not complete | Cloud-backed before/after metrics |
| Final control matrix | Not complete | Evidence-linked control matrix |
| Final risk register | Not complete | Findings, residual risks and remediation status |
| AWS/GCP/Azure mapping | Not complete | Provider-agnostic control mapping |
| RU/EN final reports | Not complete | Final reports after evidence completion |
| Publication safety final pass | Not complete | Redaction, final secret scan and repository cleanup |

---

## Corrected Roadmap From This Point

| Next Phase | Purpose | Cloud Usage |
|---|---|---|
| Phase 12.7 | Bootstrap/OIDC/Audit Cloud-Run Plan | No |
| Phase 12.8 | Bootstrap Cloud-Run: IAM, OIDC/WIF, audit/logging, registry/storage | Yes, controlled |
| Phase 12.9 | Managed Kubernetes Baseline/Remediation Cloud-Run Plan | No |
| Phase 13.0 | Controlled Managed Kubernetes baseline and remediation cloud-run | Yes, controlled |
| Phase 13.1 | Audit evidence package | Maybe, only if needed |
| Phase 13.2 | Cloud-backed remediation metrics | No or minimal |
| Phase 13.3 | Final control matrix and risk register | No |
| Phase 13.4 | AWS/GCP/Azure mapping | No |
| Phase 13.5 | RU/EN final reports | No |
| Phase 13.6 | Publication safety and final release package | No |

---

## Execution Rule

Any cloud run must have:

- explicit scope;
- expected resources;
- budget boundary;
- evidence collection;
- sensitive data handling;
- cleanup or retention decision;
- post-run resource inventory;
- final git evidence.
