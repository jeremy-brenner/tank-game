resource "google_dns_managed_zone" "tanks_zone" {
  name        = local.clean_dns_zone
  dns_name    = "${var.dns_zone}."
  description = "DNS zone - ${var.dns_zone}"
  depends_on = [google_project_service.cloudfunctions]
}

resource "google_dns_record_set" "tanks" {
  name         = "${local.dns_record}."
  type         = "A"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.tanks_zone.name
  rrdatas      = [google_compute_global_address.tanks.address]
}