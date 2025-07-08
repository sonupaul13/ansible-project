project_id = "sunlit-cab-463104-m6"  # my-second-project-463910  sunlit-cab-463104-m6
# region = "us-central1"
# zone = "us-central1-a"
region = "asia-southeast1"
zone = "asia-southeast1-a"
services = {
  vm_instance = {
    enabled = true
    instances = [
      {
        name         = "yashwanth-atlantis-vm1"
        machine_type = "e2-standard-4"
        image        = "rocky-linux-9-v20250611"
        zone         = "asia-southeast1-a"
        username = "ansible-user"
      },
      {
        name         = "yashwanth-atlantis-vm2"
        machine_type = "e2-standard-4"
        image        = "rocky-linux-9-v20250611"
        zone         = "asia-southeast1-a"
        username = "ansible-user"
      }
    ]
  }

  bucket = {
    enabled = false
    buckets = [
      # {
      #   name          = "sandeep-bucket-1"
      #   location      = "ASIA"
      #   force_destroy = true
      #   storage_class = "STANDARD"
      # },
      # {
      #   name          = "sandeep-bucket-2"
      #   location      = "US"
      #   force_destroy = false
      #   storage_class = "NEARLINE"
      # }
    ]
  }

  vpc_network = {
    enabled = false
    networks = [
      # {
      #   name                    = "sandeep-vpc-1"
      #   auto_create_subnetworks = false
      #   description             = "VPC network for Sandeep's project"
      #   subnets = [
      #     {
      #       name               = "sandeep-subnet-1"
      #       region             = "asia-southeast1"
      #       ip_cidr_range      = "10.10.0.0/24"
      #       private_ip_google_access = true
      #     }
      #   ]
      # },
      # {
      #   name                    = "sandeep-vpc-2"
      #   auto_create_subnetworks = true
      #   description             = "Another VPC network for Sandeep's project"
      #   subnets                 = []
      # }
    ]
  }

  service_account = {
    enabled = false
    service_accounts = [
      # {
      #   account_id        = "sandeep-service-account-1"
      #   display_name = "Sandeep Service Account 1"
      #   description = "Service account for Sandeep's project 1"
      #   project_id = "sunlit-cab-463104-m6"
      # },
      # {
      #   account_id        = "sandeep-service-account-2"
      #   display_name = "Sandeep Service Account 2"
      #   description = "Service account for Sandeep's project 1"
      #   project_id = "sunlit-cab-463104-m6"
      # }
    ]
  }

}