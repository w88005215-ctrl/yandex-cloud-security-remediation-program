# Generated Evidence Gitleaks Handling

## Status

Completed.

## Purpose

Phase 13.4 introduced generated SBOM and vulnerability scanner artifacts from controlled demo images.

These files are evidence artifacts, not application secrets or infrastructure credentials. Because SBOM and vulnerability reports can contain high-entropy strings, package metadata, hashes, URLs, and scanner output that resemble secrets, gitleaks may flag generated evidence files after they are committed into Git history.

## Decision

A strict `.gitleaks.toml` configuration is used.

The allowlist is limited only to generated evidence paths:

- `evidence/sbom/*.json`
- `evidence/vulnerability/*.json`
- `evidence/vulnerability/*.txt`
- `evidence/metrics/supply_chain_vulnerability_metrics.json`
- `evidence/metrics/supply_chain_vulnerability_metrics.txt`

The allowlist does not cover source code, Terraform, GitHub Actions workflows, Kubernetes manifests, kubeconfigs, private keys, service account keys, tokens, or runtime state.

## Security boundary

This is not a general bypass.

If gitleaks reports findings outside the generated evidence paths, the phase must fail and the finding must be reviewed as a potential real secret exposure.

## Result

The repository keeps SBOM and vulnerability evidence while preserving secret scanning for all operational project files.
