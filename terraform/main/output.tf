output "trigger_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}

output "zone_nameservers" {
  value = google_dns_managed_zone.tanks_zone.name_servers
}