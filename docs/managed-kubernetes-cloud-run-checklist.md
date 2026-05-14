# Managed Kubernetes Cloud-Run Checklist

## Before apply

| Check | Required |
|---|---|
| Promo and budget status reviewed | Yes |
| Bootstrap OIDC and Audit resources retained | Yes |
| GitHub Actions OIDC validated | Yes |
| Audit Trails delivery validated | Yes |
| Terraform plan saved outside public repository | Yes |
| Expected resources documented | Yes |
| Evidence directory prepared | Yes |
| Destroy path documented | Yes |
| No secrets in repository | Yes |

## During cloud-run

| Step | Evidence |
|---|---|
| Terraform init, validate, plan | command output |
| Terraform apply | sanitized command output |
| Cluster inventory | sanitized command output |
| Node readiness | kubectl get nodes |
| Insecure baseline deployment | kubectl get all, manifests, scanner output |
| Baseline scans | Trivy, kube-score, kubescape, Checkov/Kubernetes policy output |
| Remediation deployment | hardened manifests and policy output |
| After scans | same scanner family as before |
| RBAC validation | kubectl auth can-i |
| NetworkPolicy validation | policy inventory and controlled connectivity test |
| Audit Trails validation | sanitized object listing or event evidence |
| Destroy | Terraform destroy output |
| Zero-resource check | Yandex Cloud inventory after destroy |

## After cloud-run

| Check | Required |
|---|---|
| Sanitized evidence committed | Yes |
| Raw evidence kept outside repository | Yes |
| No kubeconfig committed | Yes |
| No Terraform state committed | Yes |
| No token or key committed | Yes |
| gitleaks passed | Yes |
| Before/after metrics updated | Yes |
| Cloud evidence gap register updated | Yes |
