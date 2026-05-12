# Publication Safety Checklist

## Purpose

This checklist protects the public GitHub repository from leaking credentials, cloud identifiers, state files, audit logs, billing data or personal data.

It must be completed before public release and before important pushes.

## Never publish

Do not commit:

- Terraform state files;
- Terraform local cache;
- kubeconfig files;
- Yandex Cloud service account keys;
- authorized key JSON files;
- IAM tokens;
- OAuth/OIDC tokens;
- private keys;
- raw audit logs;
- billing exports;
- unredacted screenshots;
- personal data;
- payment data.

## File patterns that must not be committed

Forbidden examples:

- *.tfstate
- *.tfstate.*
- .terraform/
- .env
- *.pem
- *.key
- *kubeconfig*
- authorized_key.json
- service_account_key.json
- yc-sa-key.json
- *.token
- raw-audit-logs/
- billing-data/
- evidence/raw/

## Manual review checklist

Before publication:

| Check | Status |
|---|---|
| .gitignore reviewed | Required |
| git status reviewed | Required |
| git diff reviewed | Required |
| gitleaks scan passed | Required |
| Terraform state absent | Required |
| kubeconfig absent | Required |
| service account keys absent | Required |
| IAM/OIDC tokens absent | Required |
| raw audit logs absent | Required |
| billing data absent | Required |
| screenshots redacted | Required |
| audit evidence redacted | Required |
| personal data removed | Required |
| payment data removed | Required |

## Required commands

Run before public push:

    git status --short
    git diff --cached
    find . -name "*.tfstate*" -o -iname "*kubeconfig*" -o -name "*.pem" -o -name "*.key" -o -name "*.token"
    gitleaks detect --source . --no-banner

## Screenshot review

Screenshots must not expose:

- personal account names;
- email addresses;
- payment or billing details;
- full cloud identifiers unless needed;
- tokens;
- access keys;
- kubeconfig content.

## Audit log review

Raw audit logs must not be committed.

Only sanitized logs may be committed under:

    evidence/sanitized/

## Final release gate

The repository is publication-ready only if:

- all required docs are complete;
- evidence supports the stated outcomes;
- no secrets are present;
- no sensitive screenshots are present;
- no raw logs are present;
- no billing data is present;
- final scans are saved as evidence.
