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

<!-- YCSEC-12.8A-GAP-UPDATE -->

## Phase 12.8A gap update — Bootstrap/OIDC/Audit implementation prepared

Current status:

- Bootstrap/OIDC/Audit cloud-run plan is complete.
- Terraform implementation package is prepared.
- Controlled cloud-run driver is prepared.
- GitHub Actions OIDC token smoke workflow template is prepared.
- Real cloud evidence is not yet claimed until Phase 12.8B succeeds.

Remaining gap:

- Execute controlled bootstrap cloud-run.
- Capture sanitized apply/output evidence.
- Capture OIDC token smoke evidence from GitHub Actions.
- Capture Audit Trails/Object Storage evidence.
- Record retention or destroy decision.

## Phase 12.8B Bootstrap/OIDC/Audit repair status

Status: completed infrastructure provisioning, validation pending.

Completed:
- GitHub Actions service account.
- Workload Identity OIDC federation.
- Federated credential scoped to the GitHub repository and branch.
- Container Registry.
- Object Storage bucket for Audit Trails delivery.
- Audit Trails trail.

Still pending:
- GitHub Actions OIDC token exchange validation.
- Audit Trails event export validation.
- Registry image/security workflow validation.
- Controlled cleanup after evidence collection.

## Phase 12.8D update — GitHub Actions OIDC validation

Status: closed.

Bootstrap/OIDC retained resources were used to validate GitHub Actions authentication to Yandex Cloud through Workload Identity Federation. The workflow uses GitHub OIDC token exchange and validates access through the Yandex Cloud Resource Manager API.

## Phase 12.8E — Audit Trails delivery validation

Status: closed for bootstrap Audit Trails delivery.

Closed evidence gap:
- Audit Trails trail is active.
- Audit Trails Object Storage destination exists.
- At least one Audit Trails object delivery was observed.
- Public evidence is sanitized.
- Raw audit metadata remains outside the repository.

## Phase 12.8F — Registry and evidence storage validation

Status: closed for bootstrap registry/evidence-storage retention validation.

Closed evidence gap:
- Container Registry exists and is retained for later image/security evidence.
- Object Storage audit/evidence bucket exists.
- Audit Trails remains active.
- GitHub Actions OIDC identity resources remain available.
- Managed registry vulnerability scanning is not claimed as closed in this phase; it remains assigned to the later container security evidence stage.

## Phase 12.9 — Managed Kubernetes baseline/remediation cloud-run plan

Status: planned.

Next cloud evidence target:

- Real Managed Kubernetes baseline/remediation cloud-run.
- Insecure baseline evidence.
- Hardened/remediated state evidence.
- Before/after metrics.
- Audit Trails evidence for cloud control-plane activity.
- Destroy and zero-resource verification for Managed Kubernetes resources.

Still open:

- Real Managed Kubernetes insecure baseline cloud evidence.
- Real Managed Kubernetes remediation cloud evidence.
- Container/image vulnerability scan evidence.
- Final cloud before/after remediation metrics.

## Phase 13.0A — Managed Kubernetes cloud-run implementation package

Status: implementation package prepared.

Closed by this phase:

- Terraform package for real Managed Kubernetes cloud-run prepared.
- Insecure baseline manifests prepared for cloud validation.
- Hardened remediation manifests prepared for cloud validation.
- Kyverno policy-as-code package prepared.
- Controlled cloud-run script prepared with explicit approval gate.
- Destroy-after-run behavior prepared.
- Private evidence handling prepared.
- Static validation package prepared.

Still open:

- Real Managed Kubernetes cluster creation evidence.
- Real node readiness evidence.
- Real insecure baseline cloud evidence.
- Real remediation cloud evidence.
- Scanner before and after outputs from cloud context.
- Audit Trails evidence for Managed Kubernetes lifecycle.
- Terraform destroy evidence for Managed Kubernetes resources.
- Zero-resource verification after Managed Kubernetes destroy.
- Final cloud before/after metrics.

## Phase 13.0 — Managed Kubernetes baseline/remediation cloud-run

Status: Managed Kubernetes baseline/remediation cloud-run: completed.

Closed evidence:

- Real Managed Kubernetes cluster lifecycle evidence.
- Insecure baseline deployment evidence.
- Hardened/remediated deployment evidence.
- Before/after scanner evidence.
- RBAC validation evidence.
- NetworkPolicy validation evidence.
- Pod security context validation evidence.
- Terraform destroy evidence.
- Post-destroy zero-resource inventory for Managed Kubernetes, Compute, and Network Load Balancer resources.

Remaining future work:

- Final control matrix.
- Final risk register.
- Final remediation metrics summary.
- AWS/GCP/Azure control mapping.
- Final RU/EN portfolio reports.
- Publication safety review.
- Final cleanup of retained bootstrap resources after all cloud evidence is no longer needed.

## Phase 13.1 — Supply Chain Security roadmap extension

Status: planned.

New evidence targets:

- GitHub Actions OIDC registry build/push validation.
- Container image SBOM generation.
- Container vulnerability scan before/after evidence.
- Yandex Container Registry image push and inventory evidence.
- Kyverno admission policy enforcement evidence.
- Insecure deployment denial evidence.
- Hardened deployment acceptance evidence.
- Audit Trails evidence for supply-chain and Kubernetes control-plane activity.
- Final cleanup of retained bootstrap resources after all cloud evidence is complete.

Still open:

- Supply-chain implementation package.
- CI/OIDC image build and push cloud evidence.
- SBOM evidence.
- Trivy and Grype before/after image scan evidence.
- Registry image inventory evidence.
- Admission policy enforcement cloud evidence.
- Final bootstrap resource cleanup evidence.

## Phase 13.2 — Supply Chain implementation package

Status: completed as local package after execution.

Cloud resources created: none.

Closed by this phase:

- Controlled demo workload package for supply-chain validation.
- Vulnerable dependency baseline and remediation target.
- Insecure and hardened Dockerfile pair.
- GitHub Actions OIDC registry build/push workflow package.
- Local SBOM/vulnerability evidence helper.
- Kyverno admission policy package.
- Static validator for the supply-chain package.

Still open after this phase:

- Real OIDC-based image build and push to Yandex Container Registry.
- Registry inventory evidence for pushed images.
- SBOM evidence generated from the controlled image/workload.
- Vulnerability before/after metrics.
- Admission policy enforcement evidence in Kubernetes.

## Phase 13.3 — Supply Chain OIDC Registry validation

Status: completed.

Closed evidence:

- GitHub Actions OIDC assertion request.
- Direct Yandex Cloud IAM token exchange.
- Yandex Cloud API validation using federated identity.
- Docker authentication to Yandex Container Registry.
- Controlled insecure and hardened demo image build/push.

Still open:

- Registry vulnerability scan evidence.
- SBOM evidence.
- Kyverno admission policy enforcement evidence.
- Final supply-chain before/after metrics.

## Phase 13.4 — SBOM and vulnerability validation

Status: completed.

Closed evidence:

- SBOM evidence for registry-pushed insecure and hardened container images.
- Trivy vulnerability scan evidence.
- Grype vulnerability scan evidence.
- Before/after supply-chain vulnerability metrics.
- Registry-backed image validation without committed cloud credentials.

Remaining supply-chain evidence target:

- Admission policy enforcement validation in Kubernetes.

## Phase 13.5A — Kyverno MKS repair package

Status: completed locally after commit.

Purpose:

- Repair kubeconfig handling for the Kyverno Managed Kubernetes validation run.
- Remove undeclared Terraform variable usage from the rerun path.
- Preserve the admission enforcement evidence target for the next paid cloud-run.

Still open:

- Successful short-lived Managed Kubernetes Kyverno admission enforcement rerun.
- Public evidence proving insecure workload denial.
- Public evidence proving hardened workload admission allow.
- Post-destroy evidence for the Kyverno MKS rerun.

## Phase 13.5A1 — Kyverno denial attribution fix

Status: completed locally after commit.

Purpose:

- Prevent Kubernetes Pod Security Admission from taking ownership of the insecure workload denial.
- Require Kyverno-specific denial evidence in the corrected Phase 13.5B rerun.
- Preserve the quality of the admission policy enforcement claim.

Still open:

- Successful Phase 13.5B paid Kyverno admission enforcement rerun on short-lived Managed Kubernetes.

## Phase 13.5A2 — Kyverno MKS runner hardening

Status: local repair package completed.

No cloud resources were created.

Purpose:

- Stabilize the corrected Kyverno admission validation runner before another paid Managed Kubernetes rerun.
- Prevent repeated paid reruns caused by image-tag detection, cleanup trap, kubeconfig, or undeclared Terraform variable issues.

Next required cloud evidence:

- Corrected Phase 13.5B/13.5C paid Kyverno Managed Kubernetes admission validation.

<!-- phase-13-5-kyverno-admission:start -->
## Phase 13.5 — Kyverno admission policy enforcement validation

Status: closed.

Closed evidence gap:

- Runtime Kubernetes admission-policy enforcement.
- Kyverno policy-as-code validation on real Yandex Managed Kubernetes.
- Insecure workload denial evidence.
- Hardened workload allow-path evidence.
- Post-run cleanup evidence for short-lived Managed Kubernetes resources.

Remaining follow-up:

- Consolidate final remediation metrics.
- Update final control matrix.
- Update final risk register.
- Prepare publication readiness review.
- Decide whether retained bootstrap resources should remain for demonstration or be destroyed in a final cleanup phase.
<!-- phase-13-5-kyverno-admission:end -->

## Phase 13.6 — Final remediation metrics consolidation

Status: Closed.

Phase 13.6 consolidates validated cloud evidence into final remediation metrics.

Closed evidence domains:

- GitHub Actions OIDC without long-lived cloud keys.
- Audit Trails / evidence storage validation.
- Managed Kubernetes baseline/remediation cloud-run.
- Supply-chain registry push validation.
- SBOM and vulnerability validation.
- Kyverno admission policy enforcement on Yandex Managed Kubernetes.
- Temporary Managed Kubernetes cleanup and zero-resource verification.

Remaining non-cloud documentation work:

- final control matrix;
- final risk register;
- AWS/GCP/Azure mapping;
- final README/publication review;
- final retained bootstrap resource cleanup decision.

<!-- YCSEC:PHASE-13.7-FINAL-CONTROL-MATRIX:START -->

## Phase 13.7 — Final Control Matrix

Status: completed.

Cloud activity: none. This was a local-only consolidation phase.

Closed evidence item:

- Final control matrix created and mapped to existing committed evidence.

Remaining finalization items:

- Final risk register.
- AWS/GCP/Azure control mapping.
- Final RU/EN portfolio reports.
- Publication safety review.
- Final retained bootstrap resource cleanup decision.
<!-- YCSEC:PHASE-13.7-FINAL-CONTROL-MATRIX:END -->
