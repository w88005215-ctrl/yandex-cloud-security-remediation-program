# Supply Chain Security Implementation Package

## Status

Implemented as a local package.

## Purpose

This phase prepares the supply-chain security evidence track for the Yandex Cloud Security Remediation Program.

It adds:

- controlled vulnerable dependency baseline;
- hardened dependency target;
- insecure and hardened Dockerfiles;
- SBOM/vulnerability evidence helper;
- GitHub Actions workflow for future OIDC-based registry build/push validation;
- Kyverno admission policy package;
- package validator.

## Roadmap position

Previous completed evidence blocks:

- Bootstrap IAM/OIDC/Audit resources.
- GitHub Actions OIDC token exchange.
- Audit Trails delivery.
- Registry and evidence storage validation.
- Managed Kubernetes baseline/remediation cloud-run.
- Managed Kubernetes before/after evidence closeout.
- Supply-chain roadmap extension.

This phase does not create cloud resources.

## Added artifacts

| Artifact | Purpose |
|---|---|
| supply-chain/demo-app | controlled vulnerable/remediated demo workload |
| .github/workflows/supply-chain-oidc-registry-validation.yml | future registry build/push validation through GitHub OIDC |
| scripts/run-supply-chain-local-evidence.sh | local SBOM/vulnerability evidence helper |
| scripts/validate-supply-chain-package.sh | static package validator |
| policies/kyverno/supply-chain/registry-and-image-policy.yaml | registry/image admission controls |

## Security boundaries

The intentionally vulnerable baseline uses outdated packages and insecure image configuration for controlled defensive validation. It does not contain exploit code, malware, secrets, or offensive payloads.

## Next phase

Phase 13.3 should run the GitHub Actions workflow and prove:

- GitHub OIDC token exchange works for registry push;
- no static cloud key is used;
- insecure and hardened images are built;
- images are pushed to Yandex Container Registry;
- sanitized workflow evidence is collected;
- registry inventory confirms pushed images.
