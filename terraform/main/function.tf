
locals {
  jar_folder = "${local.project_root}/backend/build/libs"
  jar_file = "tanks-0.1-all.jar"
  tanks_zip = "${path.root}/jars/tanks.zip"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${local.jar_folder}/${local.jar_file}"
  output_path = local.tanks_zip
}

resource "google_storage_bucket" "function_jars" {
  name     = "function-jars"
  location = "US"
}

resource "google_storage_bucket_object" "jar_file" {
  name   = "tanks.zip"
  bucket = google_storage_bucket.function_jars.name
  source = local.tanks_zip
}

resource "google_cloudfunctions_function" "function" {
  name        = "tanks-func"
  description = "tanks function"
  runtime     = "java17"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function_jars.name
  source_archive_object = google_storage_bucket_object.jar_file.name
  ingress_settings      = "ALLOW_ALL"
  trigger_http          = true
  entry_point           = "io.micronaut.gcp.function.http.HttpFunction"
}


resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}


resource "google_compute_region_network_endpoint_group" "function_neg" {
  name                  = "tanks-api-neg"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloudfunctions_function.function.region
  cloud_function {
    function = google_cloudfunctions_function.function.name
  }
}

resource "google_compute_backend_service" "api" {
  name          = "tanks-api-backend"
  backend {
    group = google_compute_region_network_endpoint_group.function_neg.id
  }
}
