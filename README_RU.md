# Yandex Cloud Security Remediation Program

Terraform + IAM/OIDC + Managed Kubernetes Hardening + Audit Evidence

## Статус проекта

**Статус:** завершённый portfolio-grade cloud security remediation case.

Репозиторий демонстрирует evidence-driven программу cloud security remediation, реализованную на реальной managed cloud infrastructure. Проект закрывает полный цикл: от фиксации insecure baseline до remediation as code, policy enforcement, supply-chain validation, cleanup evidence, public sanitization и финальной отчётности.

Финальное состояние:

- Финальные RU/EN technical reports завершены.
- Финальный двуязычный PDF-отчёт размещён в корне репозитория рядом с `README.md`.
- Cloud evidence collection завершён.
- Managed Kubernetes baseline/remediation evidence завершён.
- GitHub Actions OIDC validation выполнен без долгоживущих cloud keys.
- Supply-chain validation, SBOM, vulnerability metrics, Kyverno policy enforcement, Checkov и Gitleaks gates завершены.
- Retained bootstrap resources удалены после evidence validation.
- Public repository audit, sanitization и publication artifact curation завершены.
- Final remediation metrics, control matrix, risk register и cross-cloud mapping опубликованы.

## Финальный PDF-отчёт

- [Final PDF Report — RU/EN](yandex_cloud_security_remediation_final_report_ru_en.pdf)
- [PDF report index](docs/final-pdf-report.md)

## Основные финальные отчёты

- [Final Technical Report EN](docs/final-technical-report-en.md)
- [Final Technical Report RU](docs/final-technical-report-ru.md)
- [Final Project Completion Report EN](docs/final-project-completion-report-en.md)
- [Final Project Completion Report RU](docs/final-project-completion-report-ru.md)
- [Final Remediation Metrics](docs/final-remediation-metrics.md)
- [Final Control Matrix](docs/final-control-matrix.md)
- [Final Risk Register](docs/final-risk-register.md)
- [Cross-Cloud Control Mapping](docs/final-cross-cloud-control-mapping.md)
- [Publication Readiness](docs/final-publication-readiness.md)
- [Final Repository Audit RU](docs/final-repository-audit-ru.md)
- [Publication Sanitization Report RU](docs/publication-sanitization-report-ru.md)
- [Evidence Index](docs/evidence-index.md)

## Что демонстрирует проект

- Terraform / OpenTofu infrastructure as code.
- Yandex Cloud IAM и least-privilege service accounts.
- GitHub Actions OIDC / Workload Identity Federation без long-lived cloud keys.
- SAML/SSO federation pattern.
- Yandex Managed Service for Kubernetes.
- Insecure Kubernetes baseline и hardened remediation state.
- RBAC least privilege, NetworkPolicy и Pod Security Standards.
- Kyverno policy-as-code admission control.
- CI/CD security gates.
- Container Registry workflow validation.
- SBOM generation в формате CycloneDX.
- Vulnerability evidence через Trivy и Grype.
- IaC validation через Checkov.
- Secret scanning через Gitleaks.
- Audit Trails evidence и cleanup evidence.
- Before/after remediation metrics.
- Final control matrix и risk register.
- Conceptual AWS/GCP/Azure control mapping.

## Корректное позиционирование

Репозиторий демонстрирует practical cloud security engineering на Yandex Cloud и концептуально мапит эквивалентные controls на AWS, GCP и Azure.

Проект нельзя описывать как:

- AWS/GCP/Azure production experience.
- Непрерывную эксплуатацию live production cloud.
- Владение чужой production-инфраструктурой.
- Репозиторий, содержащий live cloud credentials, Terraform state, kubeconfig files, PEM keys или retained cloud runtime artifacts.

Корректная формулировка:

> Production-like cloud security remediation program on real managed cloud infrastructure with provider-agnostic controls mapped conceptually to AWS/GCP/Azure.

## Структура репозитория

Основные области:

- `terraform/` — Terraform environments и infrastructure definitions.
- `kubernetes/` — insecure baseline, hardened manifests, RBAC, NetworkPolicy, PSS и Kyverno policies.
- `.github/workflows/` — CI/CD security gates и OIDC-based validation workflows.
- `docs/` — architecture, final reports, control matrix, risk register, mapping, publication readiness и audit reports.
- `evidence/` — curated sanitized evidence, metrics и validation outputs.
- `scripts/` — helper scripts для validation, evidence collection, redaction, cost checks и cleanup checks.
- `presentation/` — presentation outline.
- `yandex_cloud_security_remediation_final_report_ru_en.pdf` — финальный двуязычный PDF-отчёт в корне репозитория.

## Evidence model

Проект использует evidence-first модель:

- command outputs хранятся в `evidence/command-outputs/`;
- baseline findings хранятся в `evidence/before/`;
- remediation evidence хранится в `evidence/after/`;
- sanitized audit artifacts хранятся в `evidence/sanitized/`;
- final metrics хранятся в `evidence/metrics/`;
- final reports и governance documents хранятся в `docs/`.

Публичное дерево было очищено от низкоценного промежуточного execution noise, при этом финальные отчёты, метрики, validated security evidence, audit reports, sanitization records и publication boundary documentation сохранены.

## Security and publication safety

Репозиторий проверен на отсутствие:

- Terraform state files;
- kubeconfig files;
- service account keys;
- IAM/OIDC tokens;
- PEM/private key material;
- raw audit logs;
- billing data;
- unredacted sensitive evidence;
- personal or payment data.

Финальная проверка включала Gitleaks, Checkov, repository safety checks, public artifact curation и final publication consistency cleanup.

## Для кого проект

Проект подготовлен для:

- GitHub portfolio review;
- technical interview discussion;
- cloud security / DevSecOps demonstration;
- academic or training project defense;
- security engineering review.

