# CI/OIDC Registry Build-Push Plan

## Purpose

This plan extends the already validated GitHub Actions OIDC flow into a real container delivery workflow.

## Existing evidence

The project has already validated:

- GitHub Actions OIDC token request.
- Direct Yandex Cloud IAM token exchange.
- Yandex Cloud API access with federated IAM token.
- No long-lived cloud key material in CI.

## New CI workflow target

The next workflow should perform:

1. Checkout repository.
2. Request GitHub OIDC token.
3. Exchange GitHub OIDC token for Yandex Cloud IAM token.
4. Authenticate to Yandex Container Registry without static keys.
5. Build baseline container image.
6. Build hardened container image.
7. Generate SBOM with Syft.
8. Scan images with Trivy and Grype.
9. Push images to Yandex Container Registry.
10. Save sanitized scan summaries.
11. Confirm no static cloud key material was used.

## Repository variables

Expected GitHub repository variables:

- YCSEC_YC_SA_ID
- YCSEC_YC_FOLDER_ID
- YCSEC_YCR_REGISTRY_ID

Secrets should not be required for Yandex Cloud authentication.

## Evidence targets

Planned public evidence:

- sanitized GitHub Actions log;
- SBOM summary;
- vulnerability scan summaries;
- registry push summary;
- no-static-key confirmation;
- registry image inventory summary.

Raw CI logs, if they contain sensitive data, must be stored outside the public repository.

## Success criteria

The phase succeeds only if:

- GitHub Actions workflow succeeds;
- Yandex Cloud IAM token is obtained through OIDC;
- image push to Yandex Container Registry succeeds;
- SBOM files are generated;
- image scans are completed;
- public evidence is sanitized;
- gitleaks passes.
