variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "workload_identity_pool_id" {
  type        = string
  default     = "github-pool"
  description = "ID of the workload identity pool"
}

variable "workload_identity_pool_provider_id" {
  type        = string
  default     = "github-provider"
  description = "ID of the workload identity pool provider"
}
