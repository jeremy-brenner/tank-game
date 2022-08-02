locals {
  enabled_services = [ 
    "dns", 
    "cloudfunctions", 
    "cloudbuild",
  ]
}

resource "google_project_service" "cloudfunctions" {
  for_each = toset(local.enabled_services)
  project = var.project_id
  service = "${each.key}.googleapis.com"
}