locals {
  module_name = "iam"
  name_prefix = "${var.project_name}-${var.environment}"
  labels = merge(
    var.labels,
    {
      project     = var.project_name
      environment = var.environment
      module      = "iam"
      managed_by  = "terraform"
    }
  )
}
