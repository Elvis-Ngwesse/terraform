# -----------------------------------------------
# Terraform block to define backend configuration
# -----------------------------------------------
terraform {
  backend "gcs" {}
}

# --------------------------------------------------
# Provider configuration for Google Cloud Platform
# --------------------------------------------------
provider "google" {
  credentials = var.credentials_file
  project     = var.project_id
  region      = var.region
}

# ------------------------------------------------------
# Resource block to create a Compute Engine instance
# ------------------------------------------------------
resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = var.zone

  # -------------------------------
  # Boot disk configuration
  # -------------------------------
  boot_disk {
    initialize_params {
      image = var.image_name
    }
  }

  # -----------------------------------------
  # Network interface with external access
  # -----------------------------------------
  network_interface {
    network = "default"
    access_config {} # Enables external IP
  }
}

# -----------------------------------------
# Output to display the instance name
# -----------------------------------------
output "instance_name" {
  value = google_compute_instance.default.name
}
