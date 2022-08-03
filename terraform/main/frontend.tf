
locals {
  dist_dir = "${local.project_root}/frontend/dist"
}

resource "google_storage_bucket" "frontend" {
  name          = "tanksfrontendvue"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  # cors {
  #   origin          = ["http://dunno.yet"]
  #   method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  #   response_header = ["*"]
  #   max_age_seconds = 3600
  # }

  depends_on = [google_project_service.cloudfunctions]
}

resource "google_storage_bucket_iam_member" "frontend" {
  bucket = google_storage_bucket.frontend.name

  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "dist" {
  for_each = fileset(local.dist_dir, "**")

  name    = each.key
  source = "${local.dist_dir}/${each.key}"
  bucket = google_storage_bucket.frontend.name
  cache_control = "public, max-age=30"
}

resource "google_compute_backend_bucket" "tanksfrontendvue" {
  name        = "tanksfrontendvue"
  description = "Tanks frontend"
  bucket_name = google_storage_bucket.frontend.name
  enable_cdn  = true
  edge_security_policy = google_compute_security_policy.policy.id
}

resource "google_compute_security_policy" "policy" {
  name        = "tanksfrontendvue"
  description = "basic security policy"
  type = "CLOUD_ARMOR_EDGE"
}
