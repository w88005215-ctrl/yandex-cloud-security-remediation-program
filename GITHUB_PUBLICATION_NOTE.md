# GitHub Publication Note

## Publication status

This repository is intended to become public after final redaction and security review.

## Public positioning

This project demonstrates a production-like cloud security remediation program on real managed cloud infrastructure using Yandex Cloud.

The control model is provider-agnostic and is mapped to AWS/GCP/Azure patterns, but the project must not be represented as AWS/GCP/Azure production experience.

## What can be public

The following artifacts may be published after review:

- Terraform modules without state or secrets
- Kubernetes manifests without real secrets
- GitHub Actions workflows without tokens
- sanitized command outputs
- sanitized screenshots
- sanitized audit evidence
- before/after metrics
- risk register
- control matrix
- final RU/EN reports
- presentation outline

## What must not be public

Do not publish:

- Terraform state
- kubeconfig files
- service account keys
- IAM tokens
- OAuth/OIDC tokens
- raw Audit Trails logs
- billing exports
- personal data
- payment data
- unredacted screenshots
- private cloud identifiers where not required for evidence

## Required checks before public push

Before public release:

1. Review git status.
2. Review git diff.
3. Run gitleaks.
4. Search for state, kubeconfig and key files.
5. Review screenshots manually.
6. Review audit logs manually.
7. Confirm that only sanitized evidence is committed.
8. Confirm that cost and billing details are not exposed.

## Reviewer note

The repository is structured to support technical review:

- README files explain project purpose and scope.
- docs/ contains architecture, threat model and control mapping.
- evidence/ contains proof of execution.
- reports/ contains final RU/EN reports.
- terraform/ and kubernetes/ contain implementation artifacts.
