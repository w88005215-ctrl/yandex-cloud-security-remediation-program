variable "project_name" {
  description = "Project name."
  type        = string
  default     = "yandex-cloud-security-remediation-program"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "bootstrap"
}

variable "cloud_id" {
  description = "Yandex Cloud ID. Do not commit real values."
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID. Do not commit real values."
  type        = string
  sensitive   = true
}

variable "default_zone" {
  description = "Default Yandex Cloud zone."
  type        = string
  default     = "ru-central1-a"
}

variable "labels" {
  description = "Common labels."
  type        = map(string)
  default = {
    owner       = "portfolio"
    cost_center = "ycsec-lab"
    purpose     = "security-remediation"
  }
}
