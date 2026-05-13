locals {
  module_name = "object-storage"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "object-storage"
      managed_by  = "terraform"
    }
  )
}
