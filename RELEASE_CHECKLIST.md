# Release Checklist

## Repository safety

- [ ] .gitignore reviewed
- [ ] git status reviewed
- [ ] git diff reviewed
- [ ] no Terraform state files
- [ ] no kubeconfig files
- [ ] no service account keys
- [ ] no IAM tokens
- [ ] no OIDC tokens
- [ ] no raw audit logs
- [ ] no billing data
- [ ] no unredacted screenshots
- [ ] no personal or payment data

## Required security scans

- [ ] gitleaks scan completed
- [ ] Trivy filesystem scan completed
- [ ] Checkov scan completed
- [ ] Kubernetes manifest validation completed
- [ ] container image scan completed where applicable
- [ ] SBOM generated where applicable

## Evidence checks

- [ ] evidence index updated
- [ ] command outputs saved
- [ ] screenshots redacted
- [ ] before evidence collected
- [ ] after evidence collected
- [ ] before/after metrics completed
- [ ] audit evidence sanitized
- [ ] risk register updated
- [ ] control matrix updated

## Cloud cost checks

- [ ] budget documented
- [ ] promo code status documented
- [ ] expected resources documented before cloud-run
- [ ] terraform plan saved before apply
- [ ] cost checked after cloud-run
- [ ] resource inventory updated
- [ ] expensive resources destroyed when not needed

## Kubernetes checks

- [ ] insecure baseline reproduced
- [ ] privileged workload detected or denied
- [ ] root container issue remediated
- [ ] resource requests and limits applied
- [ ] RBAC least privilege applied
- [ ] NetworkPolicy applied
- [ ] Pod Security Standards applied
- [ ] Kyverno policies applied
- [ ] remediation evidence collected

## Documentation checks

- [ ] README.md completed
- [ ] README_RU.md completed
- [ ] README_EN.md completed
- [ ] PORTFOLIO_SUMMARY.md completed
- [ ] architecture documentation completed
- [ ] threat model completed
- [ ] risk register completed
- [ ] control matrix completed
- [ ] AWS/GCP/Azure mapping completed
- [ ] final RU report completed
- [ ] final EN report completed
- [ ] presentation outline completed

## Final release decision

- [ ] repository is safe to publish
- [ ] project is honestly positioned
- [ ] no false AWS/GCP/Azure production claims
- [ ] evidence supports stated outcomes
- [ ] expensive cloud resources are destroyed
