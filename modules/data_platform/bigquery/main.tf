# data "google_bigquery_datasets" "datasets" {
#   project = var.project_id
# }

# locals {
#   dataset_exists = contains(data.google_bigquery_datasets.datasets.datasets[*].dataset_id, var.dataset_id)
# }

# BigQuery Dataset
resource "google_bigquery_dataset" "app_dataset" {
  # count                      = data.external.check_dataset.result.found == "false" ? 1 : 0
  # count                      = local.dataset_exists ? 0 : 1
  dataset_id                 = var.dataset_id
  project                    = var.project_id
  # friendly_name              = "${var.environment} Analytics Dataset"
  location                   = var.location
  delete_contents_on_destroy = var.force_destroy
  deletion_policy            = var.deletion_policy

  labels = {
    managed_by  = "terraform"
  }
}

