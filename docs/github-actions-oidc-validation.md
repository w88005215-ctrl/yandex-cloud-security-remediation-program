# GitHub Actions OIDC Validation

## Status

Implemented and validated.

## Objective

Validate that GitHub Actions can authenticate to Yandex Cloud through Workload Identity Federation without long-lived cloud key material.

## Validation method

The workflow performs the following sequence:

1. Requests a GitHub Actions OIDC ID token.
2. Exchanges the GitHub OIDC token for a Yandex Cloud IAM token.
3. Uses the IAM token to call the Yandex Cloud Resource Manager API.
4. Records successful validation in sanitized public evidence.

## Security value

This closes the CI/CD authentication control for the bootstrap cloud security track:

- no static service account key is stored in GitHub;
- authentication is scoped to the GitHub repository and main branch;
- the IAM token is short-lived;
- the validation result is reproducible through GitHub Actions.

## Evidence

- `evidence/command-outputs/YCSEC_12_8D_OUTPUT_github_actions_oidc_validation_success.txt`
- `.github/workflows/cloud-deploy-oidc.yml`
- `ci/github-oidc-validation-trigger.md`
