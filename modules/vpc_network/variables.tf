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

# variable "networks" {
#   type = list(object({
#     name                    = string
#     auto_create_subnetworks = bool
#     description             = string
#     subnets = list(object({
#       name                     = string
#       region                   = string
#       ip_cidr_range            = string
#       private_ip_google_access = bool
#     }))
#   }))
# }

variable "networks" {
  type = list(object({
    name                    = string
    auto_create_subnetworks = bool
    description             = string
    subnets = list(object({
      name                    = string
      region                  = string
      ip_cidr_range           = string
      private_ip_google_access = bool
    }))
  }))
  default = []
}
