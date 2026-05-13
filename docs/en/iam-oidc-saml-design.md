# IAM, OIDC and SAML design

## Purpose

This document describes the project identity model.

Objectives:

- eliminate long-lived cloud keys for CI/CD;
- use GitHub Actions OIDC for automation access;
- use a SAML/SSO pattern for human access;
- apply least privilege;
- prepare Terraform design for the cloud-run phase.

## Identity types

### Human identity

Human identity is used for:

- review;
- manual approval;
- emergency access;
- cloud console observation.

Model:

- access through a SAML/SSO federation pattern;
- roles are assigned to groups, not individual users;
- privileged access must be limited and documented.

### Automation identity

Automation identity is used for:

- Terraform plan;
- controlled Terraform apply after approval;
- security scanning;
- evidence collection.

Model:

- GitHub Actions receives temporary access through OIDC;
- long-lived service account keys are not used;
- trust must be scoped to repository, branch and workflow context.

## Service account model

Planned service accounts:

| Service account | Purpose | Expected roles |
|---|---|---|
| ycsec-github-plan-sa | Terraform plan and validation | read-only and minimal planning roles |
| ycsec-github-apply-sa | Controlled Terraform apply | limited resource management roles |
| ycsec-audit-sa | Audit evidence collection | audit and log read roles |
| ycsec-runtime-sa | Kubernetes workload identity pattern | minimal runtime access |

## OIDC trust constraints

OIDC trust must be scoped to:

- GitHub organization or user;
- repository name;
- branch;
- workflow file;
- audience;
- environment where applicable.

## SAML/SSO pattern

SAML/SSO is used as the human access design pattern.

Planned groups:

| Group | Purpose |
|---|---|
| ycsec-viewers | Read-only review access |
| ycsec-auditors | Audit evidence review |
| ycsec-operators | Controlled operational access |
| ycsec-admins | Break-glass only |

## Security decisions

- CI/CD must not use static cloud keys.
- Service account keys must not be published.
- Terraform state must not be published.
- Apply runs only after explicit approval.
- Human privileged access must be explained in the risk register.

## Evidence

Evidence will be stored in:

- evidence/command-outputs;
- docs/evidence-index.md;
- docs/resource-inventory.md;
- reports/final-report-ru.md;
- reports/final-report-en.md.
