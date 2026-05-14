# Supply Chain OIDC Registry Validation

## Status

Completed.

## Purpose

This phase validates that GitHub Actions can build and push controlled demo container images into Yandex Container Registry using GitHub OIDC federation and direct Yandex Cloud IAM token exchange.

## Validated controls

- GitHub Actions requested an OIDC assertion.
- The OIDC assertion was exchanged for a short-lived Yandex Cloud IAM token.
- Yandex Cloud API access was validated with the federated IAM token.
- Docker authenticated to Yandex Container Registry with IAM token authentication.
- Controlled insecure and hardened demo images were built and pushed.
- No durable cloud credential file was used by the workflow.

## Evidence

- evidence/command-outputs/YCSEC_13_3_OUTPUT_failed_build_log_analysis.txt
- evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation.txt
- evidence/command-outputs/YCSEC_13_3_OUTPUT_supply_chain_oidc_registry_validation_success.txt
- evidence/command-outputs/YCSEC_13_3_OUTPUT_registry_inventory_after_push.txt

## Claim boundary

This phase closes OIDC-based CI registry push evidence. Registry vulnerability scanning, SBOM evidence, and admission policy enforcement remain separate supply-chain validation phases.
