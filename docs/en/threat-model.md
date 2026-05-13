# Threat model

## Purpose

This threat model describes the main threats for the project and maps them to Terraform, IAM, OIDC, Kubernetes hardening and evidence workflow controls.

## Assets

Key assets:

- Yandex Cloud folder;
- Terraform code;
- Terraform plan output;
- GitHub repository;
- GitHub Actions workflows;
- service accounts;
- OIDC federation trust;
- Kubernetes cluster;
- Kubernetes workloads;
- container images;
- audit logs;
- sanitized evidence;
- final reports.

## Trust boundaries

Trust boundaries:

- developer workstation;
- GitHub repository;
- GitHub Actions runner;
- Yandex Cloud IAM;
- Yandex Cloud Managed Kubernetes;
- container registry;
- audit and evidence storage;
- public GitHub release.

## Threats

### T01 — Long-lived cloud key leakage

Description:

A long-lived service account key may be accidentally published to GitHub.

Impact:

- unauthorized cloud access;
- resource creation;
- data exposure;
- budget abuse.

Controls:

- OIDC instead of static keys;
- gitleaks scan;
- sensitive file denylist;
- no service account keys in repository.

Evidence:

- gitleaks output;
- publication safety checklist;
- OIDC design document.

### T02 — Overprivileged CI/CD identity

Description:

The CI/CD identity may receive overly broad roles.

Impact:

- privilege escalation;
- destructive cloud changes;
- unauthorized access to audit data.

Controls:

- least privilege service account;
- environment-specific roles;
- branch and repository scoped OIDC trust;
- Terraform IAM review.

Evidence:

- IAM module;
- control matrix;
- Terraform plan evidence.

### T03 — Terraform state exposure

Description:

Terraform state may contain sensitive metadata.

Impact:

- infrastructure disclosure;
- secret disclosure;
- access path exposure.

Controls:

- no tfstate in Git;
- remote backend pattern;
- .gitignore;
- sensitive file scan.

Evidence:

- sensitive file check output;
- .gitignore;
- backend design.

### T04 — Public Kubernetes workload exposure

Description:

An insecure baseline workload may expose services too broadly.

Impact:

- unauthorized network access;
- attack surface expansion;
- lateral movement.

Controls:

- NetworkPolicy default deny;
- namespace isolation;
- service exposure review;
- no public LoadBalancer without approval.

Evidence:

- before and after manifests;
- network policy evidence;
- kubescape or kube-score output.

### T05 — Privileged Kubernetes workload

Description:

A workload may run as root or with unsafe capabilities.

Impact:

- container breakout risk;
- node compromise risk;
- data tampering.

Controls:

- Pod Security Standards;
- runAsNonRoot;
- readOnlyRootFilesystem;
- drop capabilities;
- Kyverno enforcement.

Evidence:

- hardened manifests;
- Kyverno policy output;
- before and after metrics.

### T06 — Missing audit trail

Description:

Cloud actions and remediation steps may not be traceable.

Impact:

- weak auditability;
- weak reviewer confidence;
- inability to prove remediation.

Controls:

- command evidence;
- Audit Trails design;
- evidence index;
- resource inventory.

Evidence:

- command outputs;
- docs/evidence-index.md;
- audit module.

### T07 — Budget exhaustion

Description:

Managed Kubernetes and public resources may create unexpected cost.

Impact:

- budget overrun;
- resource sprawl.

Controls:

- no apply without approval;
- expected resource list;
- destroy checklist;
- cost check;
- short-lived cloud-runs.

Evidence:

- docs/cost-control.md;
- resource inventory;
- destroy checklist evidence.

## Residual risk

Some risks remain by design during insecure baseline phases.

They must be:

- documented;
- time-boxed;
- remediated;
- measured in before and after metrics.
