locals {
  module_name = "network"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "network"
      managed_by  = "terraform"
    }
  )
}
