# Terraform architecture

## Purpose

This document describes the IaC model for the Yandex Cloud Security Remediation Program.

The Terraform layer demonstrates a production-like approach:

- reusable modules;
- separated environments;
- local validation before cloud-runs;
- security gates;
- evidence-first workflow;
- cost-control before paid resources.

## Environments

bootstrap:

- foundation IAM;
- OIDC federation;
- audit evidence storage;
- registry;
- low-cost resources.

dev:

- local and short cloud validation;
- Kubernetes baseline testing;
- remediation testing.

prod-like:

- production-like control mapping;
- final evidence;
- before/after remediation metrics.

## Modules

network:

- VPC;
- subnets;
- security groups;
- ingress and egress boundaries.

iam:

- service accounts;
- least privilege roles;
- separation of duties.

oidc:

- GitHub Actions OIDC;
- no long-lived cloud keys;
- repo and branch scoped trust.

audit:

- Audit Trails;
- Cloud Logging;
- evidence delivery.

registry:

- Container Registry;
- image lifecycle;
- scan evidence.

object-storage:

- evidence buckets;
- Terraform backend pattern;
- retention and redaction model.

managed-kubernetes:

- Managed Kubernetes;
- node groups;
- Workload Identity;
- hardening controls.

## Safety rule

This phase does not create any Yandex Cloud resources.

## Terraform/OpenTofu compatibility decision

Terraform is the authoritative runtime for Yandex Cloud environments.

OpenTofu is used as an additional local validation layer for provider-independent reusable modules.

Rationale:

- Terraform successfully resolves and validates the yandex-cloud/yandex provider;
- environments depend on the Yandex Cloud provider;
- reusable modules do not create cloud resources at this stage and can be validated by OpenTofu without provider-specific resolution;
- unsafe provider resolution workarounds are not used.

Cloud-runs in later phases will be executed only through Terraform after budget precheck, saved plan, destroy checklist and explicit approval.
