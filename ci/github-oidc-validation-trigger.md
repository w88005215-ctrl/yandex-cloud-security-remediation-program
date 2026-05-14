# GitHub Actions OIDC Validation Trigger

This document records the controlled GitHub Actions validation used to prove that the repository can obtain Yandex Cloud access through GitHub OIDC federation.

## Scope

The validation workflow performs a narrow control-plane check:

- GitHub Actions receives an OIDC identity token from GitHub.
- Yandex Cloud federated IAM token exchange is performed for the scoped service account.
- The workflow calls Yandex Cloud Resource Manager API to confirm cloud API access.
- No service account authorized key file is used.
- No cloud key material is committed to the repository.

## Workflow

- File: `.github/workflows/cloud-deploy-oidc.yml`
- Trigger: manual `workflow_dispatch`
- Repository variable: `YCSEC_YC_SA_ID`
- Repository variable: `YCSEC_YC_FOLDER_ID`
- Validation evidence: sanitized GitHub Actions log and command output in `evidence/command-outputs/`

## Control value

This phase demonstrates CI/CD cloud access through short-lived federated identity rather than stored cloud key files.
