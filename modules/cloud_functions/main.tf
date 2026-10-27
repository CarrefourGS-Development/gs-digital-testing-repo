# # Attempt to read the bucket (catch errors if it doesn't exist)
# data "google_storage_buckets" "check_bucket" {
#   project = var.project_id
#   prefix  = var.bucket_name
# }

# locals {
#   # Checks if the bucket already exists in GCP
#   bucket_exists = contains(data.google_storage_buckets.check_bucket.buckets[*].name, var.bucket_name)
# }

resource "google_storage_bucket" "bucket" {
  # count    = local.bucket_exists ? 0 : 1
  name     = var.bucket_name  # Every bucket name must be globally unique
  location = var.location
  uniform_bucket_level_access = true

  force_destroy = true
}

data "archive_file" "function_code" {
  type        = "zip"
  source_dir  = var.source_dir  # Replace with the local path to your source folder
  output_path = var.output_path  # Replace with the desired output path for the zipped file
}

# Upload the zipped file to the GCS bucket
resource "google_storage_bucket_object" "object" {
  # Adding the MD5 hash to the object name ensures Cloud Functions automatically 
  name   = var.object_name
  # bucket = google_storage_bucket.bucket.name
  bucket = var.bucket_name
  source = data.archive_file.function_code.output_path

  depends_on = [google_storage_bucket.bucket]
}

resource "google_cloudfunctions2_function" "function" {
  name = var.function_name
  location = var.location
 
  build_config {
    runtime = var.runtime
    entry_point = var.entry_point  # Set the entry point 
    environment_variables = var.build_environment_variables

    source {
      storage_source {
        bucket = var.bucket_name
        object = google_storage_bucket_object.object.name
      }
    }
  }
 
  service_config {
    environment_variables = var.service_environment_variables
    min_instance_count  = var.min_instance_count
    max_instance_count  = var.max_instance_count
    ingress_settings    = var.ingress_settings
    available_memory    = var.available_memory
    available_cpu       = var.available_cpu
    timeout_seconds     = var.timeout_seconds
  }
}