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
  location                 = var.location
  force_destroy            = var.force_destroy
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = var.gcs_lifecycle_age_days
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    managed_by  = "terraform"
  }
}

# Create a dummy object ending in "/" to represent a directory
resource "google_storage_bucket_object" "files_folder" {
  # count   = local.bucket_exists ? 0 : 1
  name    = "files/"
  content = " " # Non-empty string required by the provider to satisfy API payload rules
  bucket  = var.bucket_name

  depends_on = [google_storage_bucket.data_bucket]
}

# # BigQuery Dataset
# resource "google_bigquery_dataset" "app_dataset" {
#   dataset_id                 = "gep"
#   # friendly_name              = "${var.environment} Analytics Dataset"
#   location                   = var.location
#   delete_contents_on_destroy = var.force_destroy

#   labels = {
#     env = var.environment
#   }
# }