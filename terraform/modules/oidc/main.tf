locals {
  module_name = "oidc"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "oidc"
      managed_by  = "terraform"
    }
  )
}
