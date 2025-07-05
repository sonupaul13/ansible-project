resource "google_service_account" "service_account" {
  for_each = { for sa in var.service_accounts : sa.account_id => sa }

  display_name = each.value.display_name
  account_id   = each.value.account_id
  description  = each.value.description
  project      = each.value.project_id
}
