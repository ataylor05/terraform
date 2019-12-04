output "app_engine_project_number" {
  value = google_project.app_engine_project.number
}

output "app_engine_code_bucket_self_link" {
  value = google_storage_bucket.app_engine_code_bucket.self_link
}

output "app_engine_code_bucket_url" {
  value = google_storage_bucket.app_engine_code_bucket.url
}

output "app_engine_application_name" {
  value = google_app_engine_application.app.name
}

output "app_engine_application_app_id" {
  value = google_app_engine_application.app.app_id
}

output "app_engine_application_app_default_hostname" {
  value = google_app_engine_application.app.default_hostname
}