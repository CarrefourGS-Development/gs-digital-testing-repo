variable "project_id" {
  type       = string
}

variable "service_account_id" {
  type       = string
}

variable "annotations" {
  type = map(string)
  default = {}
}

variable "enabled" {
  type = bool
  default = true
}

variable "secret_data" {
  type = string
}

variable "secret_id" {
  type = string
}

variable "offset_days" {
  type = number
  default = 180
}