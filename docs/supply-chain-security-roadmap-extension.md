# Supply Chain Security Roadmap Extension

## Status

Planned.

## Purpose

This roadmap extension adds a full cloud-native supply-chain security track to the project after the Managed Kubernetes baseline/remediation cloud-run.

The existing project already demonstrates:

- Terraform-managed Yandex Cloud infrastructure.
- GitHub Actions OIDC token exchange without long-lived cloud keys.
- Audit Trails delivery validation.
- Container Registry and Object Storage resource validation.
- Managed Kubernetes insecure baseline and remediation cloud-run.
- Before/after Kubernetes hardening evidence.
- Destroy and zero-resource verification for Managed Kubernetes resources.

The next extension will demonstrate a complete DevSecOps and cloud security flow:

- CI/CD identity through GitHub Actions OIDC.
- Container image build.
- SBOM generation.
- Vulnerability scanning.
- Push to Yandex Container Registry.
- Controlled insecure deployment attempt.
- Admission policy enforcement with Kyverno.
- Hardened deployment acceptance.
- Audit Trails evidence.
- Cleanup and final remediation metrics.

## Why this strengthens the case

The current project proves cloud infrastructure and Kubernetes hardening. The supply-chain extension proves that the same security model also controls software delivery.

This makes the portfolio case stronger for:

- Cloud Security Engineer.
- DevSecOps Engineer.
- Platform Security Engineer.
- Kubernetes Security Engineer.
- Application Security / Product Security roles.

## New roadmap sequence

### Phase 13.1 — Supply-chain roadmap extension

Local-only phase. Documents the new scope, evidence targets, claim boundaries, and implementation order.

### Phase 13.2 — Supply-chain implementation package

Local-only phase. Adds:

- demo application or demo container context;
- intentionally weak baseline Dockerfile;
- hardened Dockerfile;
- SBOM generation script;
- Trivy and Grype scan script;
- GitHub Actions workflow for OIDC-based build and push;
- Yandex Container Registry validation logic;
- Kyverno admission policy package;
- Kubernetes baseline and hardened deployment manifests;
- evidence directory structure;
- implementation documentation.

No cloud resources are created in Phase 13.2.

### Phase 13.3 — CI/OIDC registry build-push validation

Controlled cloud/CI phase. Uses GitHub Actions OIDC to:

- request GitHub OIDC token;
- exchange it for Yandex Cloud IAM token;
- build baseline and hardened images;
- generate SBOM;
- scan images;
- push images to Yandex Container Registry;
- collect sanitized CI evidence;
- confirm no static cloud keys were used.

### Phase 13.4 — Admission policy enforcement cloud-run

Controlled short-lived Managed Kubernetes phase. Demonstrates:

- Kyverno policy installation;
- insecure deployment denial;
- hardened deployment acceptance;
- before/after policy results;
- NetworkPolicy and Pod Security controls;
- Audit Trails evidence;
- Managed Kubernetes destroy and zero-resource verification.

### Phase 13.5 — Final cloud evidence cleanup

Controlled cleanup phase. Destroys retained bootstrap resources after all cloud evidence is complete:

- GitHub Actions service account;
- Audit Trails service account;
- Workload Identity federation;
- federated credential;
- Container Registry;
- Object Storage audit/evidence bucket;
- Audit Trails trail.

This phase must also verify zero retained YCSEC resources unless deliberately documented.

### Phase 14.0 — Final portfolio release package

Local-only finalization phase. Produces:

- final README;
- final cloud evidence summary;
- final before/after metrics;
- control matrix;
- risk register;
- AWS/GCP/Azure mapping;
- RU/EN reports;
- publication safety review.

## Claim boundary

Allowed only after Phase 13.3 and Phase 13.4 are complete:

- The project validates secure CI/CD identity, container image scanning, registry integration, Kubernetes admission policy enforcement, and hardened deployment in a real cloud environment.

Not allowed yet:

- Full supply-chain security validation has been completed.
- Registry vulnerability scanning has been fully validated.
- Admission control has been validated in cloud.

Current status:

- Supply-chain extension is planned and documented.
