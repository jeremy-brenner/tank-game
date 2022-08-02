resource "google_dns_managed_zone" "jeremyjbrenner" {
  name        = "jeremyjbrenner"
  dns_name    = "jeremyjbrenner.net."
  description = "My DNS zone"
  depends_on = [google_project_service.cloudfunctions]
}