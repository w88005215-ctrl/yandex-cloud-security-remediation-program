# Terraform architecture

## Назначение

Этот документ описывает IaC-модель проекта Yandex Cloud Security Remediation Program.

Цель Terraform-слоя — показать production-like подход:

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

Terraform является основным runtime для Yandex Cloud environments.

OpenTofu используется как дополнительная локальная проверка для provider-independent reusable modules.

Причина:

- Terraform успешно разрешает и валидирует provider yandex-cloud/yandex;
- environments зависят от Yandex Cloud provider;
- reusable modules на текущем этапе не создают cloud resources и могут проверяться OpenTofu без provider-specific resolution;
- небезопасные обходы provider resolution не используются.

Cloud-run в следующих фазах будет выполняться только через Terraform после budget precheck, saved plan, destroy checklist и явного подтверждения.
