# Create a new GCP project using the project_creator module
module "project_creator" {
  source = "../../../modules/project_creator"

  project_id      = var.project_id
  location        = var.location
  billing_account = var.billing_account
  folder_id       = var.folder_id
  force_destroy   = var.force_destroy
}

# Enable Required APIs inside the new project
resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "eventarc.googleapis.com",
    "secretmanager.googleapis.com"
  ])
 
  project = var.project_id
  service = each.key

  disable_on_destroy = false 

  depends_on = [ module.project_creator ]
}

# Wait for API propagation (After initial API enabling, we need to wait it to propagate)
resource "time_sleep" "wait_for_api_propagation" {
  depends_on      = [google_project_service.enabled_apis]
  create_duration = "60s"
}

# Create a template bucket
module "template_bucket" {
  source = "../../modules/data_platform/bucket"

  project_id = var.project_id
  bucket_name = "c4-gs-${var.project_id}-${var.environment}"

  depends_on = [ time_sleep.wait_for_api_propagation ]
}

# Create a template dataset
module "template_bigquery_dataset" {
  source = "../../modules/data_platform/bigquery"

  project_id    = var.project_id
  project_name  = var.project_id
  dataset_id    = "template"
  location      = var.location
  force_destroy = var.force_destroy

  depends_on = [ time_sleep.wait_for_api_propagation ]
}