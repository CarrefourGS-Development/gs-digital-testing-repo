# Search for existing project by filter
data "google_projects" "app_project" {
  filter = "id:${var.project_id}"
}

locals {
  # Returns true if project is found in GCP
  project_exists = length(data.google_projects.app_project.projects) > 0
  project_name = local.project_exists ? data.google_projects.app_project.projects[0].name : var.project_id
}

# Create a new GCP project if it doesn't exist
resource "google_project" "app_project" {
  count           = local.project_exists ? 0 : 1
  name            = var.project_id
  project_id      = var.project_id
  # org_id          = var.org_id
  billing_account = var.billing_account
  folder_id       = var.folder_id

  deletion_policy = "ABANDON"
}