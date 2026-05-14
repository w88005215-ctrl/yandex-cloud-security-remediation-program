# Отчёт по публикационной очистке

Дата: 2026-05-14T19:20:56.922460+00:00

## Цель

Цель прохода — убрать из артефактов данные, повышающие риск публикации, сохранив техническую ценность evidence chain.

## Очищенные категории

- Приватные локальные пути.
- Локальные kubeconfig-пути.
- Cloud resource identifiers.
- Имена audit bucket, производные от resource identifiers.
- Scanner metadata, способная вызвать false-positive secret detection.

## Изменённые файлы

Список находится в `evidence/metrics/final_sanitization_changed_files.json`.

## Целостность evidence

Очистка не удаляет ключевые доказательные артефакты. Сохранены:

- evidence по Terraform/IaC validation;
- evidence по GitHub Actions OIDC;
- evidence по Kubernetes и Kyverno validation;
- SBOM и vulnerability evidence;
- before/after remediation metrics;
- final control matrix;
- final risk register;
- cleanup evidence.

## Ограничения

Git commit metadata не переписывается. Аудит покрывает содержимое файлов репозитория и публичные артефакты, но не provider-side logs и не внешние metadata платформ.
