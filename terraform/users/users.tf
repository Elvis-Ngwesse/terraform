


# Add provider
provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}


resource "google_project_iam_member" "viewer" {
  for_each = toset(var.viewer_users)

  project = "superb-gear-443409-t3"
  role    = "roles/viewer"
  member  = each.value
}

resource "google_service_account" "example_service_account" {
  account_id   = "example-service-account"
  display_name = "Example Service Account"
  project      = "superb-gear-443409-t3"
}

resource "google_project_iam_member" "service_account_viewer" {
  project = "superb-gear-443409-t3"
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.example_service_account.email}"
}


variable "viewer_users" {
  default = [
    "user:dopc02devops1@gmail.com",
    "user:dopc02devops2@gmail.com",
    "user:dopc02devops3@gmail.com"
  ]
}