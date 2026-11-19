variable "project_id" {
  type        = string
  description = "New GCP Project ID to create"
}

# variable "project_number" {
#   type        = string
#   description = "New GCP Project Number to create"
# }

variable "prefix" {
  type        = string
  description = "GCP Project Prefix"
}

variable "org_id" {
  type        = string
  description = "GCP Organization ID"
}

variable "folder_id" {
  type        = string
  description = "GCP Folder ID (Optional, if you want to create the project under a specific folder)"
}

variable "billing_account" {
  type        = string
  default     = "01620C-7AD1FB-2593E4"
  description = "GCP Billing Account ID"
}

variable "environment" {
  type        = string
  default     = "prod"
}

variable "location" {
  type        = string
  default     = "asia-east2"
}

variable "force_destroy" {
  type        = bool
  default     = false
}