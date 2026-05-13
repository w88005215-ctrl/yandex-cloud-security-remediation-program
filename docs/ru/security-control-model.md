# Security control model

## Назначение

Этот документ описывает модель security controls для проекта Yandex Cloud Security Remediation Program.

Цель модели — показать не просто набор Terraform и Kubernetes файлов, а управляемую программу remediation:

- определить риски;
- связать риски с контролями;
- связать контроли с evidence;
- показать before/after улучшение;
- подготовить проект к review, защите и GitHub publication.

## Scope

В область контроля входят:

- Yandex Cloud IAM;
- GitHub Actions OIDC;
- SAML/SSO design pattern;
- Terraform and OpenTofu validation;
- Managed Kubernetes baseline;
- Kubernetes hardening;
- RBAC;
- NetworkPolicy;
- Pod Security Standards;
- Kyverno policies;
- audit evidence;
- cost-control;
- publication safety.

## Control groups

### IAM and identity

Цель:

- минимизировать long-lived credentials;
- разделить роли по назначению;
- использовать least privilege;
- отделить human access от automation access.

Контроли:

- отдельные service accounts для CI/CD, audit и runtime;
- OIDC-based access для GitHub Actions;
- SAML/SSO pattern для human access;
- запрет публикации service account keys;
- регулярная проверка секретов через gitleaks.

Evidence:

- Terraform IAM module;
- OIDC design document;
- local security gate output;
- gitleaks scan evidence.

### Infrastructure as Code

Цель:

- не допустить неконтролируемых cloud changes;
- проверять Terraform до cloud-run;
- сохранять audit trail изменений.

Контроли:

- terraform fmt;
- terraform validate;
- OpenTofu compatibility validation;
- Checkov scan;
- Trivy misconfiguration scan;
- saved plan before apply;
- explicit approval before terraform apply.

Evidence:

- local security gate output;
- Terraform module files;
- GitHub Actions workflow;
- command output evidence.

### Kubernetes security

Цель:

- показать insecure baseline;
- применить hardening;
- измерить improvement.

Контроли:

- namespace isolation;
- RBAC least privilege;
- NetworkPolicy default deny;
- Pod Security Standards;
- non-root containers;
- read-only root filesystem;
- resource requests and limits;
- Kyverno policy-as-code;
- kube-score or kubescape validation.

Evidence:

- insecure manifests;
- hardened manifests;
- Kyverno policies;
- scan output;
- before/after metrics.

### Audit and evidence

Цель:

- сделать каждую фазу доказуемой.

Контроли:

- command output evidence;
- screenshots only when needed;
- sanitized evidence;
- evidence index;
- resource inventory;
- cost-control log.

Evidence:

- evidence/command-outputs;
- docs/evidence-index.md;
- docs/resource-inventory.md;
- evidence/before-after-metrics.md.

### Cost control

Цель:

- не выйти за бюджет и не оставить платные ресурсы без причины.

Контроли:

- no cloud-run without precheck;
- expected resources list;
- saved Terraform plan;
- destroy checklist;
- resource inventory;
- post-run cost check.

Evidence:

- docs/cost-control.md;
- docs/resource-inventory.md;
- destroy checklist output;
- cost check output.

## Blocking rules

Следующие события блокируют продвижение:

- Terraform syntax error;
- OpenTofu syntax error where compatibility is required;
- detected committed secret;
- Terraform state in repository;
- kubeconfig in repository;
- service account key in repository;
- missing destroy checklist before cloud-run;
- missing explicit approval before terraform apply.

## Publication rule

Перед публикацией проект должен пройти:

- gitleaks scan;
- sensitive file check;
- evidence redaction;
- README review;
- release checklist;
- GitHub publication note review.
