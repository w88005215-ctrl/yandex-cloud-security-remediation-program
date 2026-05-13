variable "project_name" {
  description = "Project name used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "labels" {
  description = "Common labels for resources."
  type        = map(string)
  default     = {}
}
