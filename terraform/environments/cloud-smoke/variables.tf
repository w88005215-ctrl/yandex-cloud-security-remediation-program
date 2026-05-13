variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID."
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder ID."
}

variable "zone" {
  type        = string
  description = "Yandex Cloud availability zone."
  default     = "ru-central1-a"
}

variable "name_prefix" {
  type        = string
  description = "Resource name prefix."
  default     = "ycsec-smoke"
}

variable "kubernetes_version" {
  type        = string
  description = "Managed Kubernetes version."
  default     = "1.32"
}
