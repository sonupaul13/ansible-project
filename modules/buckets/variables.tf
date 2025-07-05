variable "project_id" {
  description = "The ID of the project in which the resources will be created."
  type        = string
}

variable "region" {
  description = "The region in which the resources will be created."
  type        = string
}

variable "zone" {
  description = "The zone in which the resources will be created."
  type        = string
}

variable "GOOGLE_CREDENTIALS" {
  description = "Base64 encoded Google Cloud service account credentials."
  type        = string
  sensitive   = true
}

variable "buckets" {
  type = list(object({
    name          = string
    location      = string
    force_destroy = bool
    storage_class = string
  }))
}