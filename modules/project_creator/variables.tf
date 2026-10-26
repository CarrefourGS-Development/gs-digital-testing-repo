variable "project_exists" {
  type        = bool
  default     = false
  description = "Indicates whether the GCP project already exists"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "location" {
  type        = string
  default     = "asia-east2"
  description = "GCP Multi-region or region location"
}

variable "billing_account" {
  type        = string
  description = "GCP Billing Account ID"
}

variable "folder_id" {
  type        = string
  description = "GCP Folder ID (Optional, if you want to create the project under a specific folder)"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allows destroying non-empty GCS buckets/BQ datasets during cleanup"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Prevents accidental table deletion"
}