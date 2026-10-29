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