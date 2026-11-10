variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "location" {
  type        = string
  default     = "asia-east2"
  description = "GCP Multi-region or region location"
}

variable "bucket_name" {
  type        = string
  description = "GCS Bucket name for data storage/ingestion"
}

variable "gcs_lifecycle_age_days" {
  type        = number
  default     = 7
  description = "Number of days before auto-deleting old bucket objects"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allows destroying non-empty GCS buckets/BQ datasets during cleanup"
}