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
  default     = true
  description = "Allows destroying non-empty GCS buckets/BQ datasets during cleanup"
}

variable "storage_class" {
  type        = string
  default     = "STANDARD"
  description = "GCS Storage Class (e.g., STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
}

variable "protected_folders" {
  type        = set(string)
  default     = []
  nullable    = false
  description = "Set of folder paths to create (e.g., [\"raw/\", \"processed/\", \"archive/\"])"

  validation {
    condition = alltrue([
      for f in var.protected_folders : trimspace(f) != "" && f != "/"
    ])
    error_message = "Folder names cannot be empty, whitespace-only, or just '/'."
  }

  validation {
    condition = alltrue([
      for f in var.protected_folders : !startswith(f, "/")
    ])
    error_message = "Folder paths must be relative and cannot start with a leading '/' (use 'raw/' instead of '/raw/')."
  }

  validation {
    condition = alltrue([
      for f in var.protected_folders : !strcontains(f, "//") && !strcontains(f, "\\")
    ])
    error_message = "Folder paths cannot contain double slashes ('//') or backslashes ('\\')."
  }

  validation {
    condition = alltrue([
      for f in var.protected_folders : can(regex("^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*/?$", f))
    ])
    error_message = "Folder paths may only contain alphanumeric characters, hyphens (-), underscores (_), dots (.), and single forward slashes (/) for nested folders."
  }
}

variable "folder_deletion_policy" {
  type        = string
  default     = "PREVENT"
  description = "Deletion policy for managed folders (e.g., ABANDON, DELETE, PREVENT)"
}