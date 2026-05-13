# Control matrix

| Control ID | Domain | Control | Implementation artifact | Evidence | Status |
|---|---|---|---|---|---|
| IAM-01 | IAM | Use least privilege service accounts | terraform/modules/iam | Terraform plan evidence | Planned |
| IAM-02 | IAM | Avoid long-lived CI/CD keys | docs/iam-oidc-saml-design.md | OIDC evidence | Planned |
| IAM-03 | IAM | Separate human and automation access | IAM/OIDC/SAML design | control evidence | Planned |
| IAC-01 | IaC | Run terraform fmt | scripts/run-local-security-gates.sh | YCSEC_06 output | Implemented |
| IAC-02 | IaC | Run terraform validate | scripts/run-local-security-gates.sh | YCSEC_06 output | Implemented |
| IAC-03 | IaC | Run Checkov scan | scripts/run-local-security-gates.sh | YCSEC_06 output | Implemented |
| IAC-04 | IaC | Run Trivy scan | scripts/run-local-security-gates.sh | YCSEC_06 output | Implemented |
| SEC-01 | Secrets | Run gitleaks before publication | scripts/run-local-security-gates.sh | gitleaks output | Implemented |
| SEC-02 | Secrets | Block tfstate and key files | .gitignore and checks | sensitive file output | Implemented |
| K8S-01 | Kubernetes | Apply namespace isolation | kubernetes/namespaces | Kubernetes evidence | Planned |
| K8S-02 | Kubernetes | Apply RBAC least privilege | kubernetes/rbac | RBAC evidence | Planned |
| K8S-03 | Kubernetes | Apply NetworkPolicy default deny | kubernetes/network-policies | policy evidence | Planned |
| K8S-04 | Kubernetes | Apply Pod Security Standards | kubernetes/pod-security | hardening evidence | Planned |
| K8S-05 | Kubernetes | Enforce policy-as-code | kubernetes/kyverno-policies | kyverno output | Planned |
| AUD-01 | Audit | Maintain evidence index | docs/evidence-index.md | evidence index | Implemented |
| AUD-02 | Audit | Maintain resource inventory | docs/resource-inventory.md | inventory output | Implemented |
| COST-01 | Cost | Require cloud-run precheck | docs/cost-control.md | precheck output | Implemented |
| COST-02 | Cost | Require destroy checklist | scripts/destroy-checklist.sh | destroy evidence | Implemented |
| PUB-01 | Publication | Redact raw evidence | scripts/redact-evidence.sh | sanitized evidence | Implemented |
| PUB-02 | Publication | Run release checklist | RELEASE_CHECKLIST.md | release evidence | Planned |
