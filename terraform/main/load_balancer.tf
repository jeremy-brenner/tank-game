resource "google_compute_global_address" "tanks" {
  name       = "tanks-global-address"
  ip_version = "IPV4"
}

resource "google_compute_target_https_proxy" "web_https" {
  name             = "tanks-proxy"
  url_map          = google_compute_url_map.tanks.id
  ssl_certificates = [google_compute_managed_ssl_certificate.tanks.id]
}

resource "google_compute_url_map" "tanks" {
  name        = "tanks-url-map"
  description = "tanks url map"

  default_service = google_compute_backend_bucket.tanksfrontendvue.id

  host_rule {
    hosts        = [local.dns_record]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.tanksfrontendvue.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_bucket.tanksfrontendvue.id
    }
  }
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "tanks-https-forwarding-rule"
  target     = google_compute_target_https_proxy.web_https.id
  port_range = 443
  ip_address = google_compute_global_address.tanks.id
}


resource "google_compute_global_forwarding_rule" "http" {
  name       = "tanks-http-to-https"
  target     = google_compute_target_http_proxy.web_http.id
  port_range = 80
  ip_address = google_compute_global_address.tanks.id
}

resource "google_compute_target_http_proxy" "web_http" {
  name    = "tanks-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_url_map" "https_redirect" {
  name    = "tanks-https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
