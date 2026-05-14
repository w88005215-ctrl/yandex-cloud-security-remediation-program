# Evidence Redaction Notes

## Phase 13.13A — Gitleaks evidence metadata stabilization

The Trivy image vulnerability evidence contained Docker image build metadata with `GPG_KEY` environment markers inherited from upstream base image history.

These values were not project credentials, cloud keys, CI/CD secrets, or repository-owned secret material. They appeared inside scanner output as image layer metadata and triggered GitHub Actions Gitleaks `generic-api-key` detection.

The evidence was normalized by replacing the image metadata marker with `IMAGE_METADATA_PLACEHOLDER=REDACTED`. Vulnerability findings, package inventory, severity metrics, SBOM references, and remediation conclusions remain unchanged.

Historical Gitleaks fingerprints from the failed workflow were also added to `.gitleaksignore` so previously committed scanner metadata does not block repository verification.
