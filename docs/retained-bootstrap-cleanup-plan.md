# Retained Bootstrap Resource Cleanup Plan

Generated at: `2026-05-14T17:27:34.635115+00:00`

This document defines the cleanup plan for retained bootstrap resources after final publication evidence is complete.

## Cleanup boundary

This phase does not delete resources. It only documents the controlled cleanup order.

Retained bootstrap resources include:

- bootstrap Container Registry;
- bootstrap Audit Trail;
- audit evidence storage bucket;
- GitHub Actions OIDC federation and federated credential;
- bootstrap GitHub Actions service account;
- bootstrap audit service account.

## Cleanup prerequisites

Before deletion:

1. Verify all required public evidence is committed and pushed.
2. Export or preserve any required private audit evidence.
3. Confirm final reports do not depend on live cloud resources.
4. Confirm no GitHub Actions workflow still requires the retained OIDC federation or registry.
5. Confirm no future cloud evidence collection is required.

## Cleanup order

1. Disable or delete Audit Trail only after audit evidence has been preserved.
2. Remove objects from the audit evidence bucket if bucket deletion is required.
3. Delete the audit evidence bucket.
4. Delete supply-chain demo images from Container Registry.
5. Delete the Container Registry.
6. Delete GitHub OIDC federated credential.
7. Delete GitHub OIDC federation.
8. Remove IAM bindings from bootstrap service accounts.
9. Delete bootstrap service accounts.
10. Run final cloud inventory checks.
11. Commit sanitized cleanup evidence.

## Post-cleanup evidence required

The cleanup phase should produce:

- post-cleanup registry list;
- post-cleanup audit trail list;
- post-cleanup bucket list;
- post-cleanup federation list;
- post-cleanup service account list;
- gitleaks result;
- final git control evidence.

## Safety note

Do not delete retained bootstrap resources until final reports and publication evidence are complete.
