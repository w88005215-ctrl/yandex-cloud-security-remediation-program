locals {
  module_name = "audit"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "audit"
      managed_by  = "terraform"
    }
  )
}
