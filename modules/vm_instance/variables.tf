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

variable "ssh_public_key" {
    type = string
}

variable "instances" {
  type = list(object({
    name         = string
    machine_type = string
    image        = string
    zone         = string
    username = string
  }))
}