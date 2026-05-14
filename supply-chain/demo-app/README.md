# YCSEC Supply Chain Demo Application

This directory contains a controlled demo workload for supply-chain security validation.

## Files

| File | Purpose |
|---|---|
| app.py | Minimal Flask application used for image build evidence |
| requirements-vulnerable.txt | Controlled outdated dependency baseline |
| requirements-remediated.txt | Updated dependency remediation target |
| Dockerfile.insecure | Insecure baseline image build definition |
| Dockerfile.hardened | Hardened/remediated image build definition |

## Security boundary

This package is intentionally designed for defensive validation. It does not contain exploit code, malware, credentials, or offensive payloads.

## Evidence target

The package supports the next phases:

- SBOM generation
- vulnerability scan evidence
- registry build/push evidence
- admission policy validation
- before/after remediation metrics
