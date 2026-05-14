# IAM/OIDC/Audit Control Design

## Purpose

This document defines the control design for the bootstrap cloud-run.

The goal is to prove that cloud access can be designed around least privilege, short-lived identity, evidence collection and auditability.

---

## Control Objectives

| Control ID | Objective | Evidence Target |
|---|---|---|
| IAM-BOOT-01 | Deployment must use scoped service accounts | Service account list and role bindings |
| IAM-BOOT-02 | Service accounts must not use committed static keys | Secret scan and repository file checks |
| IAM-BOOT-03 | Role assignments must be limited to the bootstrap scope | IAM role binding evidence |
| OIDC-BOOT-01 | GitHub Actions should use OIDC/WIF instead of long-lived keys | OIDC token exchange or validated limitation |
| OIDC-BOOT-02 | OIDC trust should be restricted to repository and branch | Federation condition evidence |
| AUD-BOOT-01 | IAM and bootstrap actions must be auditable | Redacted audit/log event evidence |
| REG-BOOT-01 | Container Registry access must be scoped | Registry evidence and service account mapping |
| OBJ-BOOT-01 | Evidence/object storage must be controlled | Bucket/storage evidence and access scope |
| PUB-BOOT-01 | Public evidence must be sanitized | Redacted evidence files and final scan |

---

## Identity Model

The bootstrap phase should use separate identities for separate responsibilities.

| Identity | Purpose | Expected Privilege |
|---|---|---|
| Terraform bootstrap service account | Create bootstrap resources | Temporary deployment privileges |
| GitHub Actions service account | CI/CD cloud access through OIDC/WIF | Narrow scoped role set |
| Audit/evidence service account | Read or write audit/evidence artifacts | Minimal audit/storage permissions |
| Registry service account | Push/pull image validation if used | Minimal registry access |

---

## OIDC/WIF Design Intent

The intended CI/CD identity pattern is:

GitHub Actions OIDC token -> Yandex Cloud Workload Identity Federation -> short-lived IAM token -> scoped service account access.

The design must avoid:

- committed authorized keys;
- long-lived cloud credentials in GitHub secrets;
- broad cloud-level roles;
- unrestricted repository/branch trust;
- uncontrolled production deployment privileges.

---

## Audit Design Intent

The audit path must capture cloud control-plane actions related to:

- service account creation;
- IAM binding changes;
- federation creation or update;
- registry/storage creation;
- audit/logging configuration;
- cleanup actions.

Public evidence must be redacted before commit.

---

## Bootstrap Boundary

This design does not deploy workloads.

It prepares the identity, audit and supporting cloud foundation required for the later Managed Kubernetes baseline/remediation run.
