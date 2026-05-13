locals {
  module_name = "managed-kubernetes"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "managed-kubernetes"
      managed_by  = "terraform"
    }
  )
}
