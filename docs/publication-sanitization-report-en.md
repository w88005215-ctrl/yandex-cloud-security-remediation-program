# Publication Sanitization Report

Date: 2026-05-14T19:20:56.922460+00:00

## Objective

The objective of this pass was to remove publication-risk data from repository artifacts while preserving the technical value of the evidence chain.

## Sanitized categories

- Private local paths.
- Local kubeconfig paths.
- Cloud resource identifiers.
- Audit bucket names derived from resource identifiers.
- Scanner metadata that could trigger false-positive secret detection.

## Files changed

See `evidence/metrics/final_sanitization_changed_files.json`.

## Evidence integrity

The sanitization process does not remove the important control evidence. It preserves:

- Terraform/IaC validation evidence;
- GitHub Actions OIDC evidence;
- Kubernetes and Kyverno validation evidence;
- SBOM and vulnerability evidence;
- before/after remediation metrics;
- final control matrix;
- final risk register;
- cleanup evidence.

## Limitations

Git commit metadata is not rewritten. The audit covers repository file content and public artifacts, not provider-side logs or external platform metadata.
