provider "google" {
  credentials = base64decode(var.GOOGLE_CREDENTIALS)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}