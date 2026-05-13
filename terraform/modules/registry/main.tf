locals {
  module_name = "registry"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "registry"
      managed_by  = "terraform"
    }
  )
}
