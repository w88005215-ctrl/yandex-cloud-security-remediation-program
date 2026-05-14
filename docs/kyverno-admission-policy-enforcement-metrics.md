# Kyverno Admission Policy Enforcement Metrics

## Planned validation metrics

| Control | Expected result |
|---|---|
| Managed Kubernetes cluster lifecycle | Created and destroyed |
| Node readiness | Ready node observed |
| Kyverno admission controller | Installed and ready |
| Supply-chain admission policy | Applied as Enforce |
| Insecure workload | Denied |
| Hardened workload | Allowed by server-side admission validation |
| Public evidence | Sanitized |
| Private evidence | Retained outside repository |
| Terraform state | Not committed |
| Kubeconfig | Not committed |
| IAM token/key material | Not committed |

## Final metrics

Final metrics are populated only after the successful Phase 13.5 rerun.

## Denial attribution

| Check | Expected evidence |
|---|---|
| Pod Security Admission enforce disabled for validation namespace | Namespace has audit/warn labels only |
| Kyverno owns insecure workload denial | Denial output references Kyverno policy, rule, webhook, or policy message |
| Hardened workload allow path | Server-side dry-run succeeds against the same Kyverno policy set |
