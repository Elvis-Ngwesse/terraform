

provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}


resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

resource "google_storage_bucket" "storage_bucket" {
  name          = "bucket-${random_string.bucket_name.result}"
  location      = "europe-west2"
  lifecycle {
    prevent_destroy = false
  }
}

# Create a GCP Compute Engine (VM) instance
resource "google_compute_instance" "vm_instance" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  # Explicitly define dependency on the bucket creation
  depends_on = [google_storage_bucket.storage_bucket]
}
