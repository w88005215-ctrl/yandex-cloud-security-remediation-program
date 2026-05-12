# Security Policy

## Purpose

This repository is a Cloud Security / DevSecOps portfolio project. It contains infrastructure code, Kubernetes manifests, CI/CD workflows and sanitized evidence.

Because the project interacts with real cloud infrastructure, strict publication safety is required.

## Sensitive data policy

Never commit:

- Terraform state
- kubeconfig files
- Yandex Cloud service account keys
- authorized key JSON files
- IAM tokens
- OAuth/OIDC tokens
- private keys
- certificates containing private material
- raw audit logs
- billing exports
- screenshots with personal data
- screenshots with payment data
- unredacted cloud account identifiers where not required

## Required checks before commit

Before committing:

1. Review git status.
2. Review changed files.
3. Confirm that no raw evidence is staged.
4. Confirm that no cloud credentials are staged.
5. Confirm that no Terraform state is staged.
6. Confirm that no kubeconfig is staged.

## Required checks before publication

Before public GitHub publication:

- run Gitleaks;
- run Trivy filesystem scan;
- manually inspect screenshots;
- manually inspect audit evidence;
- verify that evidence is sanitized;
- verify that billing data is absent;
- verify that Terraform state is absent;
- verify that kubeconfig is absent.

## Evidence handling

Raw evidence must stay outside the public repository or inside ignored directories.

Only sanitized evidence may be committed.

## Vulnerability reporting

This is an educational and portfolio repository. If you find exposed secrets or unsafe publication artifacts, open an issue or contact the repository owner privately.

## Cloud cost safety

Managed Kubernetes clusters, compute nodes, public IP addresses and load balancers must not be left running without an active evidence collection purpose.
