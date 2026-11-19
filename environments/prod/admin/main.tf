# Enable Required APIs inside the new project
resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "bigquery.googleapis.com",
    # "storage.googleapis.com",
    "storage-component.googleapis.com",
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

  disable_on_destroy = true
  disable_dependent_services = true 
}

# Grant specific IAM roles to a set of users for the project
locals {
  target_users = [
    "user:george_lam@carrefour.com",
    "user:ken_tsui@carrefour.com",
    "user:lucy_ma@carrefour.com",
    "user:amy_nguyen@carrefour.com",
    "user:sophie_peng@carrefour.com",
    "user:martin_chau@carrefour.com",
  ]

  target_roles = toset([
    "roles/storage.objectAdmin",
    "roles/cloudfunctions.viewer",
    "roles/cloudfunctions.developer",
    "roles/cloudfunctions.invoker",
    "roles/bigquery.dataOwner",
    "roles/storage.bucketViewer",
    "roles/monitoring.viewer",
    "roles/logging.viewer",
    "roles/iam.securityReviewer",
  ])
}

resource "google_project_iam_binding" "authoritative_roles" {
  provider = google.iam_admin
  for_each = local.target_roles

  project = var.project_id
  role    = each.value
  members = local.target_users
}