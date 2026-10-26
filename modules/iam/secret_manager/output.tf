# Output key metadata
output "service_account_key_expiration" {
  value       = time_offset.sa_key_expiration.rfc3339
  description = "RFC3339 timestamp when the current key expires and rotates"
}