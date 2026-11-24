# Reference the Existing GCP Project
data "google_project" "app_project" {
  project_id = var.project_id
}

# Create a template service account for the project
module "app_service_account" {
  source = "../../../modules/iam/service_account"

  project_id                  = var.project_id
  service_account_id          = "testing-sa"
  service_account_display_name = "${var.project_name}-${var.environment}-testing-sa"
  service_account_description = "Testing Service Account for ${var.project_name} in ${var.environment} environment"
  service_account_roles       = [
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser",
    "roles/storage.objectAdmin",
    "roles/storage.admin"
  ]
}

# Create a service account key for the template service account
resource "google_service_account_key" "testing_sa_key_1" {
  # References the service account name/email exported by the module
  service_account_id = module.app_service_account.service_account_name

  # Guarantees the SA and all IAM role bindings are fully applied before creating the key
  depends_on = [
    module.app_service_account
  ]
}

# Create a secret in Secret Manager to store the service account key
module "testing_sa_key_1_secret_manager" {
  source = "../../../modules/iam/secret_manager"

  project_id = var.project_id
  service_account_id = module.app_service_account.service_account_name
  secret_id = "${module.app_service_account.service_account_id}-key-1"
  secret_data = base64decode(google_service_account_key.testing_sa_key_1.private_key)

  annotations = {
    service_account_id = module.app_service_account.service_account_name
    service_account_key_id = google_service_account_key.testing_sa_key_1.id
  }
  enabled = false
}

# Create a template bucket
# bucket name limitation (write in the script)
# • Length: Must be between 3 and 63 characters long. (Domain-named buckets using dots can be up to 222 characters total, with each dot-separated segment max 63 characters, e.g. www.example.com).
# • Allowed Characters: Only lowercase letters, numbers, dashes (-), underscores (_), and dots (.). (Note: names with dots require domain verification).
# • Start and End: Must begin and end with a letter or number.
# • IP Address: Cannot be formatted as an IP address in dotted-decimal notation (e.g., 192.168.5.4).
# • Immutability: Once created, a bucket name cannot be changed; you must create a new bucket and migrate the data.
module "create_bucket_template" {
  source = "../../../modules/data_platform/bucket"

  project_id    = var.project_id
  bucket_name   = "c4-${var.project_id}"
  location      = var.location

  storage_class = "NEARLINE" # Options: STANDARD, NEARLINE, COLDLINE, ARCHIVE
  folder_deletion_policy = "DELETE" # Options: DELETE, PROTECT, ABANDON
  folder_force_destroy = true

  protected_folders = [ 
    # "abc/", 
    # "def/",  
    # "ghi/",
    # "ghij/",
    # "1/",
    # "files/"
  ]
}

# resource "google_storage_bucket_object" "files_folder" {
#   # count   = local.bucket_exists ? 0 : 1
#   name    = "files2/" # .temp is necessary to prevent the occasional error
#   content = " " # Non-empty string required by the provider to satisfy API payload rules
#   bucket  = "c4-${var.project_id}"

#   depends_on = [module.create_bucket_template]
# }


# Declare the import mapping if the bucket already exists in GCP
# import {
#   to = module.create_bucket_template.google_storage_bucket.data_bucket
#   id = "testing-prod-27-temp" # The real bucket name in GCP
# }

# Create a template dataset
# Case Sensitivity: Dataset names are case-sensitive, meaning DatasetName and datasetname would be considered different datasets.
# Allowed Characters: Names can include lowercase letters (a-z), uppercase letters (A-Z), numbers (0-9), and underscores (_).
# Length: Dataset names can be up to 1024 characters in length.
# Starting Character: A dataset name must start with a letter (a-z, A-Z) or an underscore (_). Names starting with numbers or consisting solely of numbers do not comply with BigQuery’s naming conventions.
module "create_bigquery_dataset_template" {
  source = "../../../modules/data_platform/bigquery"

  project_id    = var.project_id
  project_name  = var.project_id
  dataset_id    = "template"
  location      = var.location
}

# Import an existing BigQuery dataset into Terraform state (requires full GCP resource path)
# import {
#   to = module.create_bigquery_dataset_template.google_bigquery_dataset.data_dataset
#   id = "projects/${var.project_id}/datasets/template"
# }

# Create a cloud function template
# When creating a cloud function, you need to create a GCS bucket to store the function code. The bucket name must be globally unique, 
# so we use the project number and location to ensure uniqueness.
# The naming convention for the bucket is: gcf-v2-sources-<project_number>-<location>
resource "google_storage_bucket" "create_cloud_function_bucket" {
  # count    = local.bucket_exists ? 0 : 1
  name     = "gcf-v2-sources-${data.google_project.app_project.number}-${var.location}"  # Every bucket name must be globally unique
  location = var.location 
  uniform_bucket_level_access = true

  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

# import {
#   to = module.create_cloud_function_bucket.google_storage_bucket.data_bucket
#   id = "gcf-v2-sources-${data.google_project.app_project.number}-${var.location}" # The real bucket name in GCP
# }

# Naming Conventions: Must be 1–63 characters, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens
module "create_cloud_function_template" {
  source = "../../../modules/cloud_functions"
  project_id           = var.project_id
  bucket_name          = google_storage_bucket.create_cloud_function_bucket.name
  object_name          = "return_template.zip"
  source_dir           = "../../../modules/cloud_functions/python/return_template"
  output_path          = "cloud_functions/return_template/return_template.zip"
  function_name        = "return_template"
  location             = var.location
  runtime              = "python313"
  entry_point          = "testing"
  min_instance_count   = 0
  max_instance_count   = 1
  ingress_settings     = "ALLOW_ALL"
  available_memory     = "512Mi"
  available_cpu        = "0.167"
  timeout_seconds      = 60
  build_environment_variables = {
  }
  service_environment_variables = {
  }

  depends_on = [
    google_storage_bucket.create_cloud_function_bucket
  ]
}

module "create_cloud_function_template2" {
  source = "../../../modules/cloud_functions"
  project_id           = var.project_id
  bucket_name          = google_storage_bucket.create_cloud_function_bucket.name
  object_name          = "return_template.zip"
  source_dir           = "../../../modules/cloud_functions/python/return_template"
  output_path          = "cloud_functions/return_template/return_template.zip"
  function_name        = "return_template2"
  location             = var.location
  runtime              = "python313"
  entry_point          = "testing"
  min_instance_count   = 0
  max_instance_count   = 1
  ingress_settings     = "ALLOW_ALL"
  available_memory     = "512Mi"
  available_cpu        = "0.167"
  timeout_seconds      = 60
  build_environment_variables = {
  }
  service_environment_variables = {
  }

  depends_on = [
    google_storage_bucket.create_cloud_function_bucket
  ]
}