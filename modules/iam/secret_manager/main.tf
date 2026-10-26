resource "time_offset" "sa_key_expiration" {
  offset_days = var.offset_days
}

# ------------------------------------------------------------------------------
# Upload Key to Secret Manager with Hard Expiration
# ------------------------------------------------------------------------------
resource "google_secret_manager_secret" "sa_key_secret" {
  project   = var.project_id
  secret_id = var.secret_id

  # Native GCP Secret Manager Expiration Timestamp
  expire_time = time_offset.sa_key_expiration.rfc3339

  replication {
    auto {}
  }

  labels = {
    managed_by = "terraform"
    expires_at = formatdate("YYYY-MM-DD", time_offset.sa_key_expiration.rfc3339)
  }

  annotations = var.annotations
}

resource "google_secret_manager_secret_version" "sa_key_secret_version" {
  secret      = google_secret_manager_secret.sa_key_secret.id
  secret_data = var.secret_data #base64decode(google_service_account_key.sa_key.private_key)

  enabled = var.enabled
}

