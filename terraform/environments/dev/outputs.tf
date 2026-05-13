output "environment" {
  description = "Environment name."
  value       = var.environment
}

output "module_inventory" {
  description = "Terraform module inventory for control and evidence mapping."
  value = {
    network            = module.network.module_name
    iam                = module.iam.module_name
    oidc               = module.oidc.module_name
    audit              = module.audit.module_name
    registry           = module.registry.module_name
    object_storage     = module.object_storage.module_name
    managed_kubernetes = module.managed_kubernetes.module_name
  }
}
