# IAM, OIDC and SAML design

## Назначение

Этот документ описывает identity модель проекта.

Цель:

- исключить long-lived cloud keys для CI/CD;
- использовать GitHub Actions OIDC для automation access;
- использовать SAML/SSO pattern для human access;
- применить least privilege;
- подготовить Terraform design для cloud-run фазы.

## Identity types

### Human identity

Human identity используется для:

- review;
- manual approval;
- emergency access;
- cloud console observation.

Модель:

- доступ через SAML/SSO federation pattern;
- роли назначаются группам, а не отдельным пользователям;
- privileged доступ должен быть ограничен и документирован.

### Automation identity

Automation identity используется для:

- Terraform plan;
- controlled Terraform apply after approval;
- security scanning;
- evidence collection.

Модель:

- GitHub Actions получает временный доступ через OIDC;
- long-lived service account keys не используются;
- trust должен быть ограничен repository, branch и workflow context.

## Service account model

Планируемые service accounts:

| Service account | Purpose | Expected roles |
|---|---|---|
| ycsec-github-plan-sa | Terraform plan and validation | read-only and minimal planning roles |
| ycsec-github-apply-sa | Controlled Terraform apply | limited resource management roles |
| ycsec-audit-sa | Audit evidence collection | audit/log read roles |
| ycsec-runtime-sa | Kubernetes workload identity pattern | minimal runtime access |

## OIDC trust constraints

OIDC trust должен быть ограничен:

- GitHub organization or user;
- repository name;
- branch;
- workflow file;
- audience;
- environment where applicable.

## SAML/SSO pattern

SAML/SSO используется как design pattern для human access.

Планируемые группы:

| Group | Purpose |
|---|---|
| ycsec-viewers | Read-only review access |
| ycsec-auditors | Audit evidence review |
| ycsec-operators | Controlled operational access |
| ycsec-admins | Break-glass only |

## Security decisions

- CI/CD не должен использовать static cloud keys.
- Service account keys не публикуются.
- Terraform state не публикуется.
- Apply выполняется только после explicit approval.
- Human privileged access должен быть объяснен в risk register.

## Evidence

Доказательства будут храниться в:

- evidence/command-outputs;
- docs/evidence-index.md;
- docs/resource-inventory.md;
- reports/final-report-ru.md;
- reports/final-report-en.md.
