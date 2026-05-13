# Kubernetes security model

## Назначение

Этот документ описывает Kubernetes security baseline для проекта Yandex Cloud Security Remediation Program.

Phase 8 является static/offline фазой. Она проверяет структуру и безопасность Kubernetes-манифестов без подключения к Kubernetes API.

Runtime-проверка переносится в Phase 9.

## Что доказывает Phase 8

Phase 8 доказывает:

- insecure baseline manifest существует;
- hardened workload manifest существует;
- namespace labels для Pod Security Standards описаны;
- RBAC readonly-модель описана;
- NetworkPolicy baseline описан;
- Kyverno policy-as-code baseline описан;
- YAML-файлы синтаксически корректны;
- insecure baseline содержит ожидаемые риски;
- hardened baseline содержит ожидаемые security controls;
- секреты и чувствительные файлы не попали в репозиторий.

## Что не доказывает Phase 8

Phase 8 не доказывает:

- что Kubernetes API принимает эти манифесты;
- что Admission Controller реально блокирует insecure workloads;
- что Kyverno CRD установлены в кластере;
- что NetworkPolicy enforced конкретным CNI;
- что Pod Security Admission работает в runtime.

Эти проверки относятся к Phase 9.

## Insecure baseline

Insecure baseline нужен не как рекомендация, а как controlled negative example.

Он показывает:

- privileged container risk;
- root user risk;
- privilege escalation risk;
- NodePort exposure risk;
- lack of resource limits;
- weak runtime constraints.

## Hardened baseline

Hardened baseline показывает remediation controls:

- non-root execution;
- disabled privilege escalation;
- read-only root filesystem;
- dropped Linux capabilities;
- RuntimeDefault seccomp;
- resource requests and limits;
- ClusterIP service instead of NodePort;
- disabled service account token automount;
- restricted Pod Security namespace labels;
- default deny NetworkPolicy;
- explicit allow rules;
- readonly RBAC;
- Kyverno policy-as-code.

## Phase 9 boundary

Phase 9 должен поднять временный локальный Kubernetes cluster, применить манифесты, проверить runtime behavior и удалить cluster после сбора evidence.
