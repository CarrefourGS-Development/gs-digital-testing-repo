# Reference the Existing GCP Project
data "google_project" "app_project" {
  project_id = var.project_id
}

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

resource "google_service_account_key" "testing_sa_key_1" {
  # References the service account name/email exported by the module
  service_account_id = module.app_service_account.service_account_name

  # Guarantees the SA and all IAM role bindings are fully applied before creating the key
  depends_on = [
    module.app_service_account
  ]
}

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

resource "google_service_account_key" "testing_sa_key_2" {
  # References the service account name/email exported by the module
  service_account_id = module.app_service_account.service_account_name

  # Guarantees the SA and all IAM role bindings are fully applied before creating the key
  depends_on = [
    module.app_service_account
  ]
}

module "testing_sa_key_2_secret_manager" {
  source = "../../../modules/iam/secret_manager"

  project_id = var.project_id
  service_account_id = module.app_service_account.service_account_name
  secret_id = "${module.app_service_account.service_account_id}-key-2"
  secret_data = base64decode(google_service_account_key.testing_sa_key_2.private_key)

  annotations = {
    service_account_id = module.app_service_account.service_account_name
    service_account_key_id = google_service_account_key.testing_sa_key_2.id
  }
  enabled = true
}

# Create a GCS bucket for the project
module "landing_bucket" {
  source = "../../../modules/data_platform/bucket"

  project_id  = var.project_id
  bucket_name = "c4-${var.project_name}-landing-${var.environment}"
  force_destroy = true
}

# Create a GCS bucket for the project
module "cloudbuild_bucket" {
  source = "../../../modules/data_platform/bucket"

  project_id  = var.project_id
  bucket_name = "c4-${var.project_name}-cloudbuild-${var.environment}"
  force_destroy = true
}

# # Create a GCS bucket for the project #Testing only
# module "temp_bucket" {
#   source = "../../../modules/data_platform/bucket"

#   project_id  = var.project_id
#   bucket_name = "testing-prod-27-temp"
#   force_destroy = true
# }

# # 1. Declare the import mapping
# import {
#   to = module.temp_bucket.google_storage_bucket.data_bucket
#   id = "testing-prod-27-temp" # The real bucket name in GCP
# }

# Create an bronze_qms BigQuery dataset for the project
module "bronze_qms_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "bronze_qms"
  location        = var.location
  force_destroy   = true
}

# Create an ops_audit BigQuery dataset for the project
module "ops_audit_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "ops_audit"
  location        = var.location
  force_destroy   = true
}

# Create an qms BigQuery dataset for the project
module "qms_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "qms"
  location        = var.location
  force_destroy   = true
}

# Create an qms_silver BigQuery dataset for the project
module "qms_silver_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "qms_silver"
  location        = var.location
  force_destroy   = true
}

# Create an silver_control BigQuery dataset for the project
module "silver_control_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "silver_control"
  location        = var.location
  force_destroy   = true
}

# Create an silver_qms BigQuery dataset for the project
module "silver_qms_bigquery_dataset" {
  source = "../../../modules/data_platform/bigquery"

  project_id      = var.project_id
  project_name    = var.project_name
  dataset_id      = "silver_qms"
  location        = var.location
  force_destroy   = true
  deletion_policy = "DELETE"
}

# # Create an temp BigQuery dataset for the project
# module "temp_bigquery_dataset" {
#   source = "../../../modules/data_platform/bigquery"

#   project_id      = var.project_id
#   project_name    = var.project_name
#   dataset_id      = "temp"
#   location        = var.location
#   force_destroy   = true
#   deletion_policy = "DELETE"
# }