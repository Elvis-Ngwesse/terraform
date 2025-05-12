
# -----------------------------
# Configure GCP Provider
# -----------------------------
provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "nginx" {
  source = "./nginx_module"
}