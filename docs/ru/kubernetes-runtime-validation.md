# Kubernetes runtime validation

## Назначение

Phase 9 проверяет Kubernetes-манифесты на локальном временном Kubernetes API.

Цель фазы — подтвердить, что манифесты из Phase 8 не только проходят статическую проверку, но и принимаются реальным Kubernetes API server.

## Модель проверки

Проверка выполняется через временный локальный kind-кластер.

В этой фазе проверяются:

- создание namespaces;
- применение insecure baseline;
- применение hardened workload;
- применение RBAC;
- применение NetworkPolicy;
- отклонение небезопасного privileged Pod в restricted namespace через Pod Security Admission;
- удаление временного локального кластера после проверки.

## Границы фазы

Phase 9 не создает Yandex Cloud ресурсы.

Phase 9 не выполняет terraform apply.

Phase 9 не использует Managed Kubernetes.

Phase 9 не сохраняет kubeconfig в репозиторий.

