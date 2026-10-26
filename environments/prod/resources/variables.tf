variable "project_id" {
  type        = string
  description = "New GCP Project ID to create"
}

variable "project_name" {
  type        = string
  description = "New GCP Project Name to create"
}

variable "project_number" {
  type        = string
  description = "New GCP Project Number to create"
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
  description = "GCP Billing Account ID"
}

variable "environment" {
  type        = string
  default     = "prod"
}

variable "location" {
  type        = string
  default     = "US"
}

variable "force_destroy" {
  type        = bool
  default     = false
}