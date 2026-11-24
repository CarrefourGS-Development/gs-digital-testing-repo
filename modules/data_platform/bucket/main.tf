# # Attempt to read the bucket (catch errors if it doesn't exist)
# data "google_storage_buckets" "check_bucket" {
#   project = var.project_id
#   prefix  = var.bucket_name
# }

# locals {
#   # Checks if the bucket already exists in GCP
#   bucket_exists = contains(data.google_storage_buckets.check_bucket.buckets[*].name, var.bucket_name)
# }

# GCS Bucket for data storage/ingestion. Only create the bucket if it DOES NOT exist
resource "google_storage_bucket" "data_bucket" {
  # count                    = local.bucket_exists ? 0 : 1
  name                     = var.bucket_name
  project                  = var.project_id
  location                 = var.location
  force_destroy            = var.force_destroy
  storage_class            = var.storage_class
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = var.retention_duration_seconds
  }

  labels = {
    managed_by  = "terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Create a dummy object ending in "/" to represent a directory
resource "google_storage_bucket_object" "files_folder" {
  # count   = local.bucket_exists ? 0 : 1
  name    = "files/.temp" # .temp is necessary to prevent the occasional error
  content = " " # Non-empty string required by the provider to satisfy API payload rules
  bucket  = var.bucket_name

  depends_on = [google_storage_bucket.data_bucket]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_managed_folder" "this" {
  for_each = toset([
    for f in var.protected_folders : endswith(f, "/") ? f : "${f}/"
  ])

  bucket        = var.bucket_name
  name          = each.value
  force_destroy = var.folder_force_destroy

  deletion_policy = var.folder_deletion_policy

  # lifecycle {
  #   prevent_destroy = true
  # }

  depends_on = [
    google_storage_bucket.data_bucket, 
    google_storage_bucket_object.files_folder
  ]
}