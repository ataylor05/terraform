data "google_organization" "organization" {
  domain = var.organization_name
}

resource "google_project" "app_engine_project" {
  name       = var.project_name
  project_id = var.project_id
  org_id     = data.google_organization.organization.name
}

resource "google_storage_bucket" "app_engine_code_bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = var.force_destroy_bucket
  project       = google_project.app_engine_projec.id
  storage_class = var.bucket_storage_class
  versioning {
    enabled     = var.bucket_versioning
  }
}

resource "google_app_engine_application" "app" {
  project     = google_project.app_engine_projec.id
  location_id = var.location
}