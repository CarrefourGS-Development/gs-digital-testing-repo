variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "project_name" {
  type        = string
  description = "GCP Project Name"
}

variable "location" {
  type        = string
  default     = "asia-east2"
  description = "GCP Multi-region or region location"
}

variable "dataset_id" {
  type        = string
  description = "BigQuery Dataset ID for data storage/ingestion"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allows destroying non-empty GCS buckets/BQ datasets during cleanup"
}

variable "deletion_policy" {
  type        = string
  default     = "PREVENT"
  description = "Sets the deletion policy for the BigQuery dataset. Options: DELETE, ABANDON, PREVENT"
}