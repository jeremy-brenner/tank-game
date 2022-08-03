resource "google_compute_managed_ssl_certificate" "tanks" {
  name = "tanks-ssl-cert"

  managed {
    domains = ["${local.dns_record}."]
  }
}
