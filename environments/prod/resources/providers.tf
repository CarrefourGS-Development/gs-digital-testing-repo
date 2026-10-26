provider "google" {
  project     = var.project_id
  region      = var.location
  # impersonate_service_account = "gs-digital-project-creator@gs-digital-root-dev.iam.gserviceaccount.com"
}

# terraform {
#   required_providers {
#     google-beta = {
#       source  = "hashicorp/google-beta"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "google-beta" {
#   project     = var.project_id
#   region      = var.location
# }