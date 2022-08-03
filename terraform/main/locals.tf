locals {
  project_root = "${path.root}/../.."
  clean_dns_zone = replace(var.dns_zone, "/[^a-zA-Z]*/", "")
  dns_record = "tanks.${var.dns_zone}"
}