# Multi-cloud control mapping

| Security area | Yandex Cloud implementation | AWS equivalent | GCP equivalent | Azure equivalent |
|---|---|---|---|---|
| IAM least privilege | Service accounts and folder roles | IAM roles and policies | IAM service accounts and roles | Managed identities and RBAC |
| CI/CD federation | GitHub OIDC to cloud identity | GitHub OIDC to IAM role | Workload Identity Federation | Federated credentials |
| Human SSO | SAML/SSO federation pattern | IAM Identity Center | Cloud Identity | Entra ID |
| Audit logs | Audit Trails and logging design | CloudTrail | Cloud Audit Logs | Azure Activity Log |
| Object evidence storage | Object Storage | S3 | Cloud Storage | Blob Storage |
| Container registry | Container Registry | ECR | Artifact Registry | ACR |
| Managed Kubernetes | Managed Service for Kubernetes | EKS | GKE | AKS |
| Network isolation | VPC, subnets, security groups | VPC and security groups | VPC firewall rules | VNet and NSG |
| Policy-as-code | Kyverno | Kyverno or OPA | Policy Controller or Kyverno | Azure Policy or Kyverno |
| Image scanning | Trivy, Grype, registry scan pattern | Inspector and Trivy | Artifact Analysis and Trivy | Defender and Trivy |
| Secret scanning | Gitleaks | GitHub secret scanning | Secret Manager review | Defender and GitHub scanning |
| Cost control | budget docs and destroy workflow | Budgets | Budgets | Cost Management |
