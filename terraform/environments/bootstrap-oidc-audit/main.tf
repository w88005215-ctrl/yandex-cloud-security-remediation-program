terraform {
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.202.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.iam_token
}

locals {
  prefix                 = "ycsec-bootstrap"
  github_subject         = "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
  github_audience        = "https://github.com/${var.github_owner}"
  github_oidc_issuer     = "https://token.actions.githubusercontent.com"
  github_oidc_jwks_url   = "https://token.actions.githubusercontent.com/.well-known/jwks"
  registry_name          = "${local.prefix}-registry"
  github_actions_sa_name = "${local.prefix}-gha-sa"
  audit_trail_sa_name    = "${local.prefix}-audit-sa"
  audit_trail_name       = "${local.prefix}-audit-trail"
  audit_object_prefix    = "audit-trails/bootstrap"
}

resource "yandex_iam_service_account" "github_actions" {
  folder_id   = var.folder_id
  name        = local.github_actions_sa_name
  description = "YCSEC GitHub Actions OIDC service account for controlled evidence run"
}

resource "yandex_iam_service_account" "audit_trail" {
  folder_id   = var.folder_id
  name        = local.audit_trail_sa_name
  description = "YCSEC Audit Trails service account for controlled evidence run"
}

resource "yandex_resourcemanager_folder_iam_member" "github_actions_viewer" {
  folder_id = var.folder_id
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.github_actions.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "github_actions_registry_pusher" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${yandex_iam_service_account.github_actions.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "audit_trail_storage_uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"
  member    = "serviceAccount:${yandex_iam_service_account.audit_trail.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "audit_trail_admin" {
  folder_id = var.folder_id
  role      = "audit-trails.admin"
  member    = "serviceAccount:${yandex_iam_service_account.audit_trail.id}"
}

resource "yandex_iam_workload_identity_oidc_federation" "github" {
  folder_id = var.folder_id
  name      = "${local.prefix}-github-oidc"
  issuer    = local.github_oidc_issuer
  audiences = [local.github_audience]
  jwks_url  = local.github_oidc_jwks_url
}

resource "yandex_iam_workload_identity_federated_credential" "github_main_branch" {
  service_account_id  = yandex_iam_service_account.github_actions.id
  federation_id       = yandex_iam_workload_identity_oidc_federation.github.id
  external_subject_id = local.github_subject
}

resource "yandex_container_registry" "bootstrap" {
  folder_id = var.folder_id
  name      = local.registry_name
}

resource "yandex_storage_bucket" "audit_evidence" {
  #checkov:skip=CKV_YC_3:Short-lived audit evidence bucket used for controlled validation; retained cleanup evidence proves removal after use.
  folder_id             = var.folder_id
  bucket                = var.audit_bucket_name
  default_storage_class = "STANDARD"
  max_size              = var.audit_bucket_max_size

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}

resource "yandex_audit_trails_trail" "bootstrap" {
  depends_on = [
    yandex_storage_bucket.audit_evidence,
    yandex_resourcemanager_folder_iam_member.audit_trail_storage_uploader,
    yandex_resourcemanager_folder_iam_member.audit_trail_admin
  ]

  folder_id          = var.folder_id
  name               = local.audit_trail_name
  service_account_id = yandex_iam_service_account.audit_trail.id

  storage_destination {
    bucket_name   = yandex_storage_bucket.audit_evidence.bucket
    object_prefix = local.audit_object_prefix
  }

  filtering_policy {
    management_events_filter {
      resource_scope {
        resource_id   = var.folder_id
        resource_type = "resource-manager.folder"
      }
    }
  }
}
