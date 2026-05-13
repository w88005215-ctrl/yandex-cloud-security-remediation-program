module "network" {
  source       = "../../modules/network"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "oidc" {
  source       = "../../modules/oidc"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "audit" {
  source       = "../../modules/audit"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "registry" {
  source       = "../../modules/registry"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "object_storage" {
  source       = "../../modules/object-storage"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}

module "managed_kubernetes" {
  source       = "../../modules/managed-kubernetes"
  project_name = var.project_name
  environment  = var.environment
  labels       = var.labels
}
