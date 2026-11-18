# # 1. Default provider (uses your current identity to deploy buckets, functions, etc.)
# provider "google" {
#   project = var.project_id
#   region  = var.location
# }

# # 2. Elevated provider alias (impersonates the central IAM Admin SA)
# provider "google" {
#   alias                       = "iam_admin"
#   project                     = var.project_id
#   region                      = var.location
#   impersonate_service_account = "gs-digital-role-granteor@gs-digital-root-dev.iam.gserviceaccount.com"
# }