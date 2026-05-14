# Cloud Evidence Gap Register

## Purpose

This register tracks the remaining evidence gaps that must be closed before the project can be presented as a complete cloud security remediation program.

---

## Gap Register

| Gap ID | Area | Gap | Current Evidence | Required Evidence | Priority | Status |
|---|---|---|---|---|---|---|
| GAP-CLOUD-001 | Bootstrap | Bootstrap resources are not fully proven as a dedicated cloud-run | Smoke-run infrastructure evidence only | IAM, service accounts, registry, object storage and audit/logging evidence | High | Open |
| GAP-IAM-001 | IAM | Least-privilege IAM model is not fully proven in cloud | Static docs / Terraform skeleton | Cloud-created service accounts and scoped role evidence | High | Open |
| GAP-OIDC-001 | OIDC/WIF | GitHub Actions OIDC without static cloud keys is not fully proven | Roadmap/design intent | Successful OIDC token exchange and restricted cloud access evidence | High | Open |
| GAP-SAML-001 | SAML/SSO | Enterprise federation pattern is not fully closed | Roadmap/design intent | SAML/SSO implementation evidence or documented validated pattern | Medium | Open |
| GAP-AUD-001 | Audit Trails | Audit trail evidence is not closed | Smoke-run command evidence | Redacted Audit Trails / Cloud Logging events for IAM, registry and cluster actions | High | Open |
| GAP-REG-001 | Container Registry | Registry flow is not proven | Not closed | Registry creation, image push/pull or documented controlled alternative | Medium | Open |
| GAP-K8S-001 | Managed Kubernetes baseline | Insecure baseline has not been applied in real Managed Kubernetes cloud-run | Static baseline validation | Real before-state cluster evidence and scans | High | Open |
| GAP-K8S-002 | Managed Kubernetes remediation | Hardened state has not been applied in real Managed Kubernetes cloud-run | Static remediation validation | Real after-state cluster evidence and scans | High | Open |
| GAP-K8S-003 | Runtime policy enforcement | Kyverno/PSS runtime behavior is not fully proven in cloud | Static policy package | Runtime policy report or denial evidence | High | Open |
| GAP-MET-001 | Metrics | Final remediation outcomes are not cloud-backed | Static before/after metrics | Cloud-backed before/after metrics | High | Open |
| GAP-RISK-001 | Risk register | Final risk register is not complete | Partial findings docs | Risk register with residual risk and evidence references | Medium | Open |
| GAP-CTRL-001 | Control matrix | Final evidence-linked matrix is not complete | Kubernetes baseline control matrix | Full cloud/IAM/OIDC/Kubernetes/audit control matrix | Medium | Open |
| GAP-MAP-001 | Provider mapping | AWS/GCP/Azure mapping is not finalized | Roadmap intent | Completed mapping document | Medium | Open |
| GAP-REP-001 | Reports | Final RU/EN reports are not complete | Case study only | Final report RU and final report EN | Medium | Open |
| GAP-PUB-001 | Publication safety | Final public release check is not complete | Interim safety checks | Final redaction, secret scan and publication checklist | High | Open |

---

## Immediate Next Closure Target

The next evidence closure target is bootstrap/OIDC/audit planning.

The next cloud run should not be Kubernetes remediation yet. First, the project must prepare a controlled bootstrap cloud-run plan covering:

- service accounts;
- least-privilege IAM roles;
- Workload Identity Federation / OIDC;
- registry/storage;
- audit/logging path;
- evidence boundaries;
- cleanup and retention model.

---

## Cloud Cost Boundary

The remaining cloud evidence must be collected through short, controlled runs.

Persistent resources should be avoided unless they are explicitly required for the next step and documented as low-cost or no-cost.

<!-- YCSEC:PHASE-12-7-PLANNING-STATUS:START -->
## Phase 12.7 Planning Status

The following gaps are now covered by a dedicated cloud-run plan, but remain open until Phase 12.8 produces real cloud evidence:

| Gap ID | Planning Status | Evidence Status |
|---|---|---|
| GAP-CLOUD-001 | Planned in docs/bootstrap-oidc-audit-cloud-run-plan.md | Open |
| GAP-IAM-001 | Planned in docs/iam-oidc-audit-control-design.md | Open |
| GAP-OIDC-001 | Planned in docs/iam-oidc-audit-control-design.md | Open |
| GAP-AUD-001 | Planned in docs/bootstrap-evidence-collection-plan.md | Open |
| GAP-REG-001 | Planned in docs/bootstrap-oidc-audit-cloud-run-plan.md | Open |
| GAP-PUB-001 | Planned in docs/bootstrap-evidence-collection-plan.md | Open |

<!-- YCSEC:PHASE-12-7-PLANNING-STATUS:END -->

