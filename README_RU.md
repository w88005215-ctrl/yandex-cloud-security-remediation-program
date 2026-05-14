# Yandex Cloud Security Remediation Program

Terraform + IAM/OIDC/SAML + Managed Kubernetes Hardening + Audit Evidence

## Назначение проекта

Этот репозиторий демонстрирует production-like cloud security remediation program на реальной managed cloud infrastructure Yandex Cloud.

Цель проекта — показать не учебную лабораторную, а полноценный portfolio-grade кейс по Cloud Security и DevSecOps: от небезопасного baseline до hardened state, с audit evidence, before/after metrics, risk register, control matrix и безопасной GitHub-публикацией.

## Что показывает проект

Проект демонстрирует:

- Terraform / OpenTofu infrastructure as code
- Yandex Cloud IAM
- least privilege для service accounts
- GitHub Actions OIDC / Workload Identity Federation без long-lived cloud keys
- SAML/SSO federation pattern
- Yandex Managed Service for Kubernetes
- insecure Kubernetes baseline
- Kubernetes hardening
- RBAC least privilege
- NetworkPolicy
- Pod Security Standards
- Kyverno policy-as-code
- CI/CD security gates
- Trivy, Checkov, Gitleaks, Syft, Grype и другие security tools
- Audit Trails evidence
- before/after remediation metrics
- risk register
- control matrix
- mapping на AWS/GCP/Azure
- RU/EN финальные отчёты

## Правильное позиционирование

Проект нельзя описывать как AWS, GCP или Azure production experience.

Правильная формулировка:

Production-like cloud security remediation program on real managed cloud infrastructure with provider-agnostic controls mapped to AWS/GCP/Azure.

## Модель работы

Проект выполняется по модели local-first + short cloud evidence runs:

1. Сначала готовим Terraform, Kubernetes manifests, CI/CD checks и evidence model локально.
2. Проверяем всё локально.
3. Только после этого коротко создаём Yandex Cloud ресурсы.
4. Собираем evidence.
5. Выполняем remediation.
6. Сравниваем before/after.
7. Проверяем расходы.
8. Уничтожаем дорогие ресурсы.

Managed Kubernetes, compute nodes, public IP и LoadBalancer нельзя оставлять включёнными без активной задачи по сбору evidence.

## Evidence-first подход

Каждая важная фаза должна оставлять доказательства:

- command outputs: evidence/command-outputs/
- screenshots: evidence/screenshots/
- baseline findings: evidence/before/
- remediation results: evidence/after/
- sanitized audit artifacts: evidence/sanitized/
- metrics: evidence/before-after-metrics.md

## Что нельзя публиковать

В публичный GitHub нельзя коммитить:

- Terraform state
- kubeconfig
- service account keys
- IAM tokens
- OIDC tokens
- raw audit logs
- billing data
- unredacted screenshots
- персональные или платёжные данные

## Для кого проект

Проект готовится для:

- GitHub portfolio
- преподавателя
- технической защиты
- собеседования на DevSecOps / Cloud Security роли
- демонстрации практического security engineering подхода

<!-- YCSEC:K8S-REMEDIATION-CASE:START -->
## Kubernetes Security Remediation Case

This repository includes a Kubernetes security remediation track that demonstrates a complete evidence-driven workflow:

readiness inventory -> baseline validation -> remediation controls -> before/after comparison -> portfolio case study.

Key documents:

- docs/kubernetes-security-remediation-case-study.md
- docs/kubernetes-baseline-validation-plan.md
- docs/kubernetes-baseline-findings.md
- docs/kubernetes-remediation-results.md
- docs/kubernetes-before-after-remediation-comparison.md

<!-- YCSEC:K8S-REMEDIATION-CASE:END -->

