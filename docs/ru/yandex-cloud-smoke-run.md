# Yandex Cloud smoke-run

## Цель

Phase 11 выполняет короткую проверку реального Yandex Cloud окружения.

Проверка должна подтвердить:

- Terraform может создать минимальную инфраструктуру;
- Managed Kubernetes API доступен;
- kubeconfig не попадает в репозиторий;
- Kubernetes-манифесты проекта применимы к реальному кластеру;
- Pod Security Admission работает на реальном API;
- ресурсы удаляются через Terraform destroy после проверки.

## Границы фазы

В этой фазе разрешено создать только временные ресурсы smoke-run:

- VPC network;
- subnet;
- service accounts;
- Managed Kubernetes zonal cluster;
- one small preemptible node group.

PersistentVolume, LoadBalancer, публичные IP для узлов и production workloads не создаются.

## Бюджет

Целевой лимит короткого запуска: до 100 ₽.

Основная стоимость:

- Managed Kubernetes zonal master: примерно 9.6624 ₽ за час;
- node group: тарифицируется как Compute Cloud;
- boot disk node group: тарифицируется как Compute Cloud disk до удаления.

После проверки выполняется terraform destroy.

## Правило остановки

Если apply прошёл, но validation не прошёл, сначала собирается evidence, затем выполняется destroy.

Если destroy не прошёл, Phase 11 считается аварийной и требует ручной проверки в Yandex Cloud Console.
