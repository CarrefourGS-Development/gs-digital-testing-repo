# Output key metadata
output "service_account_name" {
  value = google_service_account.app_service_account.name
}

output "service_account_id" {
  value = var.service_account_id
}