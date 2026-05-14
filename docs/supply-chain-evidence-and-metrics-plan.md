# Supply Chain Evidence and Metrics Plan

## Purpose

This plan defines measurable outcomes for the supply-chain extension.

## Metrics

| Area | Before | After |
|---|---|---|
| CI cloud auth | Not tied to image delivery evidence | OIDC-based image build and push validated |
| Static cloud keys | Not used in existing OIDC validation | Not used in registry build-push workflow |
| SBOM | Missing for baseline image | Generated with Syft |
| Image vulnerabilities | Baseline findings recorded | Hardened image findings reduced or classified |
| Registry integration | Registry resource exists | Image push and inventory validated |
| Admission control | Insecure manifests detectable | Insecure deployment denied or policy-flagged |
| Hardened deployment | Not yet validated through admission | Accepted by policy controls |
| Audit evidence | Audit Trails delivery validated | CI/registry/Kubernetes actions tied to audit evidence |
| Cleanup | MKS cleanup validated | MKS and final bootstrap cleanup validated |

## Planned evidence files

Phase 13.2 local package:

- docs/supply-chain-cloud-run-implementation.md
- docs/supply-chain-cloud-run-operator-runbook.md
- scripts/run-supply-chain-registry-validation.sh
- scripts/run-admission-policy-cloud-run.sh
- scripts/validate-supply-chain-package.sh
- ci/supply-chain-oidc-registry-validation.md
- container/demo-app/Dockerfile.insecure
- container/demo-app/Dockerfile.hardened
- policies/kyverno/supply-chain
- kubernetes/supply-chain/insecure
- kubernetes/supply-chain/hardened

Phase 13.3 CI/registry evidence:

- evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_registry_validation.txt
- evidence/supply-chain/sbom-baseline-summary.txt
- evidence/supply-chain/sbom-hardened-summary.txt
- evidence/supply-chain/trivy-baseline-summary.txt
- evidence/supply-chain/trivy-hardened-summary.txt
- evidence/supply-chain/grype-baseline-summary.txt
- evidence/supply-chain/grype-hardened-summary.txt
- evidence/supply-chain/ycr-image-inventory-redacted.txt

Phase 13.4 admission policy evidence:

- evidence/command-outputs/YCSEC_13_4_OUTPUT_admission_policy_cloud_run.txt
- evidence/policy/kyverno-install.txt
- evidence/policy/insecure-deployment-denied.txt
- evidence/policy/hardened-deployment-accepted.txt
- evidence/policy/policy-report.txt
- evidence/policy/network-policy-validation.txt
- evidence/policy/post-destroy-mks-zero-resource-check.txt

## Final claim target

After the extension is complete, the project can claim:

- real cloud CI/CD identity validation with OIDC;
- container image vulnerability management evidence;
- SBOM-based supply-chain visibility;
- Yandex Container Registry integration;
- Kubernetes admission policy enforcement;
- hardened deployment validation;
- audit-backed cloud activity evidence;
- controlled cleanup and zero-resource verification.
