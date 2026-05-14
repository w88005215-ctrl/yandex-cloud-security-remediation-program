# Before/After Remediation Metrics

## Purpose

This file tracks measurable security improvement across the project.

The goal is to prove that the project does not only deploy tools, but actually reduces risk.

## Metrics table

| Control Area | Before | After | Evidence |
|---|---:|---:|---|
| Static CI cloud credentials | TBD | TBD | EVID-OIDC-001 |
| GitHub cloud authentication | TBD | TBD | EVID-OIDC-002 |
| Long-lived service account keys in CI | TBD | TBD | EVID-OIDC-003 |
| IAM least privilege | TBD | TBD | EVID-IAM-001 |
| SAML/SSO federation pattern | TBD | TBD | EVID-SAML-001 |
| Terraform validation | TBD | TBD | EVID-IAC-001 |
| Checkov high findings | TBD | TBD | EVID-IAC-002 |
| Gitleaks findings | TBD | TBD | EVID-PUB-002 |
| Privileged Kubernetes pods | TBD | TBD | EVID-K8S-001 |
| Containers running as root | TBD | TBD | EVID-K8S-002 |
| Missing resource limits | TBD | TBD | EVID-K8S-003 |
| Writable root filesystem | TBD | TBD | EVID-K8S-004 |
| Missing NetworkPolicy | TBD | TBD | EVID-NET-001 |
| Broad RBAC permissions | TBD | TBD | EVID-K8S-005 |
| Pod Security Standards | TBD | TBD | EVID-K8S-006 |
| Kyverno policy enforcement | TBD | TBD | EVID-K8S-007 |
| Container image vulnerabilities | TBD | TBD | EVID-IMG-001 |
| SBOM availability | TBD | TBD | EVID-IMG-002 |
| Audit Trails coverage | TBD | TBD | EVID-AUD-001 |
| Evidence-to-control mapping | TBD | TBD | EVID-CTRL-001 |
| Cost-control process | Manual | Documented | EVID-COST-001 |
| Publication safety process | Manual | Documented | EVID-PUB-001 |

## Rules

- Before values must be based on evidence.
- After values must be based on evidence.
- If a finding remains, document it as residual risk.
- Do not claim 100% remediation unless evidence proves it.
- Prefer measurable values over vague statements.

## Residual risk notation

Use:

- Remediated
- Accepted risk
- Partially remediated
- Not applicable
- Deferred

## Reviewer note

This table will become one of the main portfolio artifacts. It should be easy to connect each row to command outputs, screenshots, scan reports and the final report.

## Phase 8 Kubernetes baseline metrics

| Control | Insecure baseline | Hardened state | Evidence |
|---|---|---|---|
| Runs as non-root | No | Yes | kubernetes/insecure-baseline, kubernetes/hardened |
| Privileged container | Yes | No | deployment securityContext |
| Privilege escalation | Allowed | Disabled | deployment securityContext |
| Read-only root filesystem | No | Yes | deployment securityContext |
| Linux capabilities | Not dropped | Drop ALL | deployment securityContext |
| Resource requests and limits | Missing | Present | deployment resources |
| Service exposure | NodePort | ClusterIP | service manifest |
| Namespace Pod Security | privileged | restricted | namespace labels |
| Network default deny | Missing | Present | NetworkPolicy manifests |
| RBAC least privilege | Missing | Present | RBAC manifests |
| Policy-as-code | Missing | Present | Kyverno policies |

## Phase 8 — Kubernetes static baseline metrics

| Area | Before | After | Evidence |
|---|---:|---:|---|
| Privileged workload example | Not documented | Documented as insecure baseline | kubernetes/insecure-baseline/demo-app-insecure.yaml |
| Root container example | Not documented | Documented as insecure baseline | kubernetes/insecure-baseline/demo-app-insecure.yaml |
| Hardened non-root workload | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Read-only root filesystem | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Dropped Linux capabilities | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| RuntimeDefault seccomp | Not documented | Documented | kubernetes/hardened/demo-app-hardened.yaml |
| Default deny NetworkPolicy | Not documented | Documented | kubernetes/network-policies/default-deny.yaml |
| Kyverno policy-as-code | Not documented | Documented | kubernetes/kyverno-policies/ |
| Runtime enforcement | Not tested in Phase 8 | Deferred to Phase 9 | docs/en/kubernetes-security-model.md |

## Phase 9 — local Kubernetes runtime validation

| Metric | Before | After |
|---|---:|---:|
| Kubernetes manifests validated only statically | Yes | No |
| Kubernetes manifests accepted by local API server | No evidence | Evidence captured |
| Restricted namespace rejects privileged Pod | No evidence | Evidence captured |
| Temporary local cluster cleanup | No evidence | Evidence captured |

<!-- YCSEC:PHASE-11-SMOKE-RUN:START -->
## Phase 11.2 — Managed Kubernetes Smoke-Run Metrics

| Control Area | Before | After | Evidence |
|---|---|---|---|
| Terraform provider authentication | Not validated against real cloud apply | Validated through runtime Yandex Cloud values | EVID-YC-SMOKE-001 |
| Managed Kubernetes provisioning | Not validated in real cloud | Real Yandex Cloud Managed Kubernetes cluster created successfully | EVID-YC-SMOKE-001 |
| Kubernetes API access | Not validated in real cloud | kubectl confirmed API reachability | EVID-YC-SMOKE-001 |
| Worker node readiness | Not validated in real cloud | kubectl confirmed Ready worker node | EVID-YC-SMOKE-001 |
| Static cloud keys in repository | Not allowed | 0 committed keys | EVID-YC-SMOKE-001 |
| Terraform runtime artifacts in repository | Not allowed | 0 Terraform state/runtime files committed | EVID-YC-SMOKE-002 |
| Kubeconfig in repository | Not allowed | 0 kubeconfig files committed | EVID-YC-SMOKE-002 |
| Temporary cloud resources after run | Unknown before verification | 0 smoke resources remaining | EVID-YC-SMOKE-002 |
| Publication-safe evidence | Raw output not suitable for publication | Sanitized evidence committed | EVID-YC-SMOKE-001 |

<!-- YCSEC:PHASE-11-SMOKE-RUN:END -->

<!-- YCSEC:PHASE-12-1-BASELINE-PLAN:START -->
## Phase 12.1 — Planned Kubernetes Baseline/Remediation Metrics

| Metric Area | Baseline Measurement | Remediation Measurement | Target Direction |
|---|---|---|---|
| Namespace Pod Security labels | Count missing labels | Count labels added or corrected | Increase control coverage |
| Workload securityContext | Count missing securityContext fields | Count hardened workload specs | Increase hardened workload coverage |
| Non-root execution | Count workloads without runAsNonRoot | Count workloads with runAsNonRoot true | Increase non-root coverage |
| Privilege escalation | Count containers without allowPrivilegeEscalation false | Count containers hardened | Reduce privilege escalation exposure |
| Capabilities | Count containers without capabilities.drop | Count containers dropping capabilities | Reduce Linux capability exposure |
| Seccomp | Count workloads without RuntimeDefault | Count workloads with RuntimeDefault | Increase runtime syscall hardening |
| NetworkPolicy | Count namespaces without policy | Count namespaces with default-deny or allow-list policy | Increase segmentation coverage |
| RBAC | Count broad or unclear bindings | Count least-privilege namespace bindings | Reduce permission scope |
| Resource governance | Count containers without requests/limits | Count containers with explicit requests/limits | Increase operational guardrail coverage |
| Policy-as-code | Count controls without automated validation | Count controls with validation path | Increase repeatability |

<!-- YCSEC:PHASE-12-1-BASELINE-PLAN:END -->

<!-- YCSEC:PHASE-12-2-BASELINE-VALIDATION:START -->
## Phase 12.2 — Kubernetes Baseline Metrics

| Metric Area | Baseline Count | Remediation Target |
|---|---:|---|
| Kubernetes YAML manifests | 12 | Preserve valid manifests and improve control coverage |
| Namespace files | 2 | Add Pod Security labels where required |
| Workload files | 2 | Harden workload securityContext |
| Service files | 3 | Keep exposure controlled |
| RBAC files | 2 | Enforce least privilege |
| NetworkPolicy files | 3 | Add or strengthen segmentation |
| Pod Security label files | 2 | Increase Pod Security label coverage |
| runAsNonRoot files | 2 | Increase non-root execution coverage |
| allowPrivilegeEscalation false files | 1 | Increase privilege escalation prevention coverage |
| capabilities/drop files | 1 | Increase Linux capability reduction coverage |
| seccomp profile files | 1 | Increase RuntimeDefault coverage |
| readOnlyRootFilesystem files | 2 | Increase read-only filesystem coverage where compatible |
| requests/limits files | 2 | Increase resource governance coverage |
| policy-as-code references | 12 | Add repeatable validation gate |

<!-- YCSEC:PHASE-12-2-BASELINE-VALIDATION:END -->

<!-- YCSEC:PHASE-12-3-REMEDIATION:START -->
## Phase 12.3 — Kubernetes Remediation Metrics

| Metric Area | Remediation Count | Result |
|---|---:|---|
| Remediation YAML manifests | 7 | Remediation package created |
| Namespace files | 1 | Dedicated remediated namespace added |
| Workload files | 1 | Hardened workload added |
| Service files | 2 | ClusterIP-only exposure added |
| RBAC files | 1 | Least-privilege RBAC added |
| NetworkPolicy files | 2 | Segmentation controls added |
| Restricted Pod Security label files | 1 | Restricted Pod Security posture added |
| runAsNonRoot files | 2 | Non-root execution control added |
| allowPrivilegeEscalation false files | 2 | Privilege escalation prevention added |
| capabilities/drop files | 2 | Linux capability reduction added |
| seccomp profile files | 2 | RuntimeDefault syscall profile added |
| readOnlyRootFilesystem files | 1 | Read-only root filesystem control added |
| requests/limits files | 2 | Resource governance added |
| policy-as-code files | 1 | Policy-as-code validation package added |

<!-- YCSEC:PHASE-12-3-REMEDIATION:END -->
