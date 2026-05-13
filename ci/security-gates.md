# Security Gates

This project uses local-first security gates before any Yandex Cloud run.

## Local gates

The local security gate validates:

- Terraform formatting;
- Terraform initialization without backend;
- Terraform validation for Yandex Cloud environments;
- OpenTofu formatting;
- OpenTofu validation for provider-independent reusable modules;
- Checkov IaC scan;
- Trivy filesystem and misconfiguration scan;
- Gitleaks secret scan;
- sensitive file checks.

## Terraform and OpenTofu decision

Terraform is the authoritative runtime for Yandex Cloud environments because the Yandex Cloud provider is resolved and validated successfully through Terraform.

OpenTofu is used as an additional local compatibility gate for provider-independent reusable modules.

This avoids unsafe provider workarounds and keeps the cloud runtime deterministic.

## Cloud gate rule

No terraform apply is allowed until:

- budget is documented;
- expected resources are listed;
- Terraform plan is saved;
- destroy checklist exists;
- evidence directory is prepared;
- secrets are not committed;
- user explicitly approves the cloud-run.

## Blocking rules

The following findings block progress:

- Terraform syntax errors;
- Terraform environment validation errors;
- OpenTofu reusable module validation errors;
- detected committed secrets;
- Terraform state files in repository;
- kubeconfig files in repository;
- service account keys in repository.

Security scan findings may be documented as risks when they are expected during an insecure baseline phase.
