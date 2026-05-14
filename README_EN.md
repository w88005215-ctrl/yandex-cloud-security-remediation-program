# Yandex Cloud Security Remediation Program

Terraform + IAM/OIDC/SAML + Managed Kubernetes Hardening + Audit Evidence

## Project overview

This repository demonstrates a production-like cloud security remediation program on real managed cloud infrastructure using Yandex Cloud.

The project is built as a portfolio-grade Cloud Security / DevSecOps case. It shows how to build an insecure baseline, detect security gaps, apply remediation, collect audit evidence and present measurable before/after outcomes.

## Key capabilities demonstrated

- Terraform / OpenTofu infrastructure as code
- Modular infrastructure design
- Yandex Cloud IAM
- Least-privilege service accounts
- GitHub Actions OIDC / Workload Identity Federation
- CI/CD without long-lived cloud credentials
- SAML/SSO federation pattern
- Yandex Managed Service for Kubernetes
- Kubernetes insecure baseline
- Kubernetes hardening
- RBAC least privilege
- NetworkPolicy
- Pod Security Standards
- Kyverno policy-as-code
- CI/CD security gates
- Container and filesystem security scanning
- SBOM generation
- Audit Trails evidence
- Before/after remediation metrics
- Risk register
- Control matrix
- AWS/GCP/Azure control mapping
- RU/EN final reports

## Positioning statement

This project must not be represented as AWS, GCP or Azure production experience.

Correct positioning:

Production-like cloud security remediation program on real managed cloud infrastructure with provider-agnostic controls mapped to AWS/GCP/Azure.

## Delivery model

The project follows a local-first and short cloud evidence run model:

1. Prepare and validate locally.
2. Run security checks before cloud deployment.
3. Create short-lived Yandex Cloud infrastructure only when evidence collection is ready.
4. Collect baseline evidence.
5. Apply remediation.
6. Collect after-state evidence.
7. Check costs.
8. Destroy expensive resources.

## Evidence model

Evidence is stored in a structured way:

- evidence/command-outputs/ for terminal output
- evidence/screenshots/ for screenshots
- evidence/before/ for insecure baseline evidence
- evidence/after/ for remediated state evidence
- evidence/sanitized/ for redacted audit artifacts
- evidence/before-after-metrics.md for measurable outcomes

## Publication safety

The public repository must not contain:

- Terraform state
- kubeconfig files
- service account keys
- cloud tokens
- raw audit logs
- billing data
- unredacted screenshots
- personal or payment information

## Audience

This project is designed for:

- GitHub portfolio review
- technical interviews
- Cloud Security / DevSecOps demonstrations
- academic or training project defense
- security architecture review

<!-- YCSEC:K8S-REMEDIATION-CASE:START -->
## Kubernetes Security Remediation Case

This repository includes a Kubernetes security remediation track that demonstrates a complete evidence-driven workflow:

readiness inventory -> baseline validation -> remediation controls -> before/after comparison -> portfolio case study.

Key documents:

- docs/kubernetes-security-remediation-case-study.md
- docs/kubernetes-baseline-validation-plan.md
- docs/kubernetes-baseline-findings.md
- docs/kubernetes-remediation-results.md
- docs/kubernetes-before-after-remediation-comparison.md

<!-- YCSEC:K8S-REMEDIATION-CASE:END -->

