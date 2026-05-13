# Security control model

## Purpose

This document defines the security control model for the Yandex Cloud Security Remediation Program.

The goal is to demonstrate a managed remediation program, not only a collection of Terraform and Kubernetes files.

The model connects:

- risks;
- controls;
- evidence;
- before and after metrics;
- GitHub publication readiness.

## Scope

The control scope includes:

- Yandex Cloud IAM;
- GitHub Actions OIDC;
- SAML/SSO design pattern;
- Terraform and OpenTofu validation;
- Managed Kubernetes baseline;
- Kubernetes hardening;
- RBAC;
- NetworkPolicy;
- Pod Security Standards;
- Kyverno policies;
- audit evidence;
- cost control;
- publication safety.

## Control groups

### IAM and identity

Objective:

- minimize long-lived credentials;
- separate duties;
- enforce least privilege;
- separate human access from automation access.

Controls:

- dedicated service accounts for CI/CD, audit and runtime;
- OIDC-based access for GitHub Actions;
- SAML/SSO pattern for human access;
- no published service account keys;
- recurring secret scans with gitleaks.

Evidence:

- Terraform IAM module;
- OIDC design document;
- local security gate output;
- gitleaks scan evidence.

### Infrastructure as Code

Objective:

- prevent uncontrolled cloud changes;
- validate Terraform before cloud-runs;
- preserve an audit trail for changes.

Controls:

- terraform fmt;
- terraform validate;
- OpenTofu compatibility validation;
- Checkov scan;
- Trivy misconfiguration scan;
- saved plan before apply;
- explicit approval before terraform apply.

Evidence:

- local security gate output;
- Terraform module files;
- GitHub Actions workflow;
- command output evidence.

### Kubernetes security

Objective:

- demonstrate an insecure baseline;
- apply hardening;
- measure improvement.

Controls:

- namespace isolation;
- RBAC least privilege;
- NetworkPolicy default deny;
- Pod Security Standards;
- non-root containers;
- read-only root filesystem;
- resource requests and limits;
- Kyverno policy-as-code;
- kube-score or kubescape validation.

Evidence:

- insecure manifests;
- hardened manifests;
- Kyverno policies;
- scan output;
- before and after metrics.

### Audit and evidence

Objective:

- make every phase verifiable.

Controls:

- command output evidence;
- screenshots only when required;
- sanitized evidence;
- evidence index;
- resource inventory;
- cost-control log.

Evidence:

- evidence/command-outputs;
- docs/evidence-index.md;
- docs/resource-inventory.md;
- evidence/before-after-metrics.md.

### Cost control

Objective:

- stay within budget and avoid leaving paid resources running.

Controls:

- no cloud-run without precheck;
- expected resources list;
- saved Terraform plan;
- destroy checklist;
- resource inventory;
- post-run cost check.

Evidence:

- docs/cost-control.md;
- docs/resource-inventory.md;
- destroy checklist output;
- cost check output.

## Blocking rules

The following events block progress:

- Terraform syntax error;
- OpenTofu syntax error where compatibility is required;
- detected committed secret;
- Terraform state in repository;
- kubeconfig in repository;
- service account key in repository;
- missing destroy checklist before cloud-run;
- missing explicit approval before terraform apply.

## Publication rule

Before publication, the repository must pass:

- gitleaks scan;
- sensitive file check;
- evidence redaction;
- README review;
- release checklist;
- GitHub publication note review.
