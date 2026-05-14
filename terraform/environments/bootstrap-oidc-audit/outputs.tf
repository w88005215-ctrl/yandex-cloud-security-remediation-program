output "github_actions_service_account_id" {
  description = "Service account ID linked to GitHub Actions OIDC"
  value       = yandex_iam_service_account.github_actions.id
}

output "workload_identity_federation_id" {
  description = "Workload Identity Federation ID for GitHub OIDC"
  value       = yandex_iam_workload_identity_oidc_federation.github.id
}

output "github_oidc_subject" {
  description = "GitHub OIDC subject restricted by federated credential"
  value       = yandex_iam_workload_identity_federated_credential.github_main_branch.external_subject_id
}

output "container_registry_id" {
  description = "Container Registry ID created for bootstrap evidence"
  value       = yandex_container_registry.bootstrap.id
}

output "audit_bucket_name" {
  description = "Object Storage bucket used as Audit Trails destination"
  value       = yandex_storage_bucket.audit_evidence.bucket
}

output "audit_trail_id" {
  description = "Audit Trails trail ID"
  value       = yandex_audit_trails_trail.bootstrap.id
}
