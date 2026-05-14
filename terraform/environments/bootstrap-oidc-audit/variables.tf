variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

variable "iam_token" {
  description = "Short-lived IAM token supplied from yc CLI at runtime"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub owner or organization used in OIDC audience and subject"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name used in OIDC subject"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to use the federated credential"
  type        = string
  default     = "main"
}

variable "audit_bucket_name" {
  description = "Globally unique Object Storage bucket name for Audit Trails evidence"
  type        = string
}

variable "audit_bucket_max_size" {
  description = "Object Storage bucket max size in bytes"
  type        = number
  default     = 104857600
}
