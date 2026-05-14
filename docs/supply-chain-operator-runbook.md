# Supply Chain Operator Runbook

## Phase 13.2

Local-only package implementation.

No cloud resources are created.

## Phase 13.3 preview

The next phase should configure the following GitHub repository variables:

| Variable | Purpose |
|---|---|
| YCSEC_YC_SA_ID | service account ID used for OIDC token exchange |
| YCSEC_YC_FOLDER_ID | Yandex Cloud folder ID for API validation |
| YCSEC_YCR_REGISTRY_ID | Yandex Container Registry ID for image push |

The workflow to dispatch:

- YCSEC Supply Chain OIDC Registry Validation

Expected evidence:

- workflow run URL;
- IAM token exchange confirmation;
- Docker login to cr.yandex using federated IAM token;
- insecure image build and push;
- hardened image build and push;
- no long-lived key material confirmation;
- sanitized workflow logs.

## Phase 13.4 preview

SBOM and vulnerability evidence should be collected from local tools and/or registry image references:

- Syft CycloneDX SBOM;
- Grype vulnerability output;
- Trivy filesystem/image output;
- before/after finding delta.

## Phase 13.5 preview

Admission policy validation should prove that Kubernetes policy enforcement blocks insecure image usage and accepts the remediated pattern.
