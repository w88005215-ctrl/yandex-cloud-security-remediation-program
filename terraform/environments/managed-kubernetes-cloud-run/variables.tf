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

variable "iam_token" {
  type        = string
  description = "Short-lived IAM token for Terraform provider."
  sensitive   = true
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "Short-lived Managed Kubernetes cluster name."
  default     = "ycsec-mks-cloud-run"
}

variable "network_cidr" {
  type        = string
  description = "CIDR block for the temporary Managed Kubernetes subnet."
  default     = "10.130.0.0/24"
}

variable "node_count" {
  type        = number
  description = "Minimal worker node count for evidence run."
  default     = 1
}

variable "node_platform_id" {
  type        = string
  description = "Yandex Compute platform ID for worker nodes."
  default     = "standard-v3"
}

variable "node_cores" {
  type        = number
  description = "Worker node CPU cores."
  default     = 2
}

variable "node_memory" {
  type        = number
  description = "Worker node memory in GB."
  default     = 4
}

variable "node_disk_type" {
  type        = string
  description = "Worker node boot disk type."
  default     = "network-hdd"
}

variable "node_disk_size" {
  type        = number
  description = "Worker node boot disk size in GB."
  default     = 32
}

variable "node_preemptible" {
  type        = bool
  description = "Use preemptible worker node for cost control."
  default     = true
}
