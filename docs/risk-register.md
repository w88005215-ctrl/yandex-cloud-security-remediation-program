# Risk register

| ID | Risk | Likelihood | Impact | Severity | Control | Evidence | Status |
|---|---|---:|---:|---:|---|---|---|
| R-001 | Long-lived cloud key leakage | Medium | High | High | OIDC, gitleaks, denylisted key files | gitleaks evidence, OIDC design | Open |
| R-002 | Overprivileged CI/CD identity | Medium | High | High | least privilege roles, scoped trust | IAM module, control matrix | Open |
| R-003 | Terraform state exposure | Medium | High | High | no state in Git, backend pattern | sensitive file checks | Open |
| R-004 | Public Kubernetes workload exposure | Medium | High | High | NetworkPolicy, service review | before/after manifests | Open |
| R-005 | Privileged Kubernetes workload | Medium | High | High | Pod Security, Kyverno | policy scan output | Open |
| R-006 | Missing audit trail | Low | High | Medium | command evidence, Audit Trails design | evidence index | In progress |
| R-007 | Budget overrun | Medium | Medium | Medium | cloud-run precheck, destroy checklist | cost-control docs | In progress |
| R-008 | Raw evidence leakage | Medium | High | High | redaction phase, sanitized evidence | publication checklist | Open |
| R-009 | CI workflow drift | Medium | Medium | Medium | GitHub Actions gates, local gates | workflow output | Open |
| R-010 | Insecure baseline misunderstood as final state | Low | High | Medium | clear before/after documentation | final report | Open |
