# GitHub Publication Note

## Publication status

This repository is public after final redaction, cleanup, repository safety review and publication artifact curation.

## Public positioning

This project demonstrates a production-like cloud security remediation program on real managed cloud infrastructure. The control model is provider-agnostic and is mapped to AWS/GCP/Azure patterns, but the project must not be represented as AWS/GCP/Azure production experience.

## What is public

The public repository may include:

- Terraform modules without state or secrets;
- Kubernetes manifests without real secrets;
- GitHub Actions workflows without tokens;
- sanitized command outputs;
- sanitized audit/evidence artifacts;
- before/after metrics;
- SBOM and vulnerability evidence;
- risk register;
- control matrix;
- final RU/EN Markdown reports;
- final bilingual PDF report in the repository root;
- repository audit and publication sanitization reports.

## What must not be public

The repository must not contain:

- Terraform state;
- kubeconfig files;
- service account keys;
- IAM tokens;
- OAuth/OIDC tokens;
- raw Audit Trails logs;
- billing exports;
- payment data;
- unredacted screenshots;
- private cloud identifiers where not required for sanitized evidence.

## Final validation state

Before final publication, the repository passed:

1. Git status and diff review.
2. Gitleaks validation.
3. Checkov validation.
4. Search for state, kubeconfig, key and environment artifacts.
5. Public artifact curation.
6. Final PDF placement in the repository root.
7. Cleanup evidence verification.

## Reviewer note

The repository is structured to support technical review:

- `README.md` explains project purpose, scope and final state.
- `docs/` contains architecture, threat model, final reports, control mapping, risk register and publication documentation.
- `evidence/` contains sanitized proof of execution and metrics.
- `terraform/` and `kubernetes/` contain implementation artifacts.
- `yandex_cloud_security_remediation_final_report_ru_en.pdf` is the final bilingual presentation-ready report.
