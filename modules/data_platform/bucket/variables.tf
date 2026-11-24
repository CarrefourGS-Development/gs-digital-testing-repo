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

variable "retention_duration_seconds" {
  type        = number
  default     = 604800 # 7 days in seconds
  description = "Duration in seconds to retain objects in the bucket"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allows destroying non-empty GCS buckets/BQ datasets during cleanup"
}

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = "GCS Storage Class (e.g., STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
}
