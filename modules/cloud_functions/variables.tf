variable "project_id" {
  description = "GCP Project ID where the Cloud Function will be deployed."
  type        = string
}

variable "bucket_name" {
  description = "Name of the Cloud Storage bucket used to store the function source."
  type        = string
}

variable "location" {
  description = "Google Cloud region for the bucket and Cloud Function."
  type        = string
}

variable "object_name" {
  description = "Name of the Cloud Storage object containing the function source archive."
  type        = string
}

variable "source_dir" {
  description = "Local path to the function source code directory."
  type        = string
}

variable "output_path" {
  description = "Path where the zipped function source code will be saved."
  type        = string
}

variable "function_name" {
  description = "Name of the Cloud Function."
  type        = string
}

variable "runtime" {
  description = "Runtime used by the Cloud Function, such as python312 or nodejs22."
  type        = string
}

variable "entry_point" {
  description = "Name of the function entry point in the source code."
  type        = string
}

variable "min_instance_count" {
  description = "Minimum number of function instances."
  type        = number
}

variable "max_instance_count" {
  description = "Maximum number of function instances."
  type        = number
}

variable "ingress_settings" {
  description = "Ingress settings controlling which traffic can reach the function."
  type        = string
}

variable "available_memory" {
  description = "Memory available to each function instance, in a supported size format."
  type        = string
}

variable "available_cpu" {
  description = "CPU available to each function instance."
  type        = string
}

variable "timeout_seconds" {
  description = "Maximum execution time for the function, in seconds."
  type        = number
}

variable "build_environment_variables" {
  description = "Environment variables for the build process of the Cloud Function."
  type        = map(string)
  default     = {}
}

variable "service_environment_variables" {
  description = "Environment variables for the Cloud Function service."
  type        = map(string)
  default     = {}
}