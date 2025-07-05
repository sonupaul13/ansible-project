resource "google_storage_bucket" "bucket_sandeep" {
  for_each      = { for b in var.buckets : b.name => b }

  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy
  storage_class = each.value.storage_class

  labels = {
    "dep" = "compliance"
  }

  lifecycle_rule {
    condition {
      age = 5
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
}

resource "google_storage_bucket_object" "object_sandeep" {
  for_each = { for b in var.buckets : b.name => b }

  name   = "iphone_logo"
  bucket = google_storage_bucket.bucket_sandeep[each.key].name
  source = "../modules/buckets/p2.jpg"
}