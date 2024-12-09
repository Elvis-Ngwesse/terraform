
#Uniform access control ensures that all objects within a bucket share the same permissions, as controlled
#by bucket-level IAM policies. This simplifies access management by removing object-level ACLs and enforcing
#uniform permissions for all objects in the bucket.



# Add provider
provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

resource "google_compute_instance" "example" {
  name         = "state-file-instance"
  machine_type = "e2-micro"
  zone         = "europe-west2-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


# Generate a random string for the bucket name
resource "random_string" "bucket_name" {
  length  = 16  # Adjust length as needed
  special = false  # Set to true if you want special characters
  upper   = false  # Set to true if you want uppercase characters
}

resource "google_storage_bucket" "my_terraform_state_bucket" {
  name          = "tf-${random_string.bucket_name.result}"  # Combine with a prefix to ensure uniqueness
  location      = "europe-west2"  # Change this to your preferred region, e.g., "europe-west2"
  force_destroy = true  # Set to true to allow deletion of a bucket even if it contains objects

  # Enforce uniform bucket-level access
  uniform_bucket_level_access = true

  # Enable versioning for the bucket
  versioning {
    enabled = true
  }

  # Optional lifecycle rule to delete objects older than 30 days
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  # Delete objects older than 30 days
    }
  }

  lifecycle {
    prevent_destroy = false  # Prevents accidental deletion of the bucket
  }
}


# Add bucket access for a user
resource "google_storage_bucket_iam_member" "user_access" {
  bucket = google_storage_bucket.my_terraform_state_bucket.name
  role   = "roles/storage.objectViewer"
  member = "user:dopc02devops@gmail.com"
}

# Public access
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.my_terraform_state_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


output "bucket_name" {
  value = google_storage_bucket.my_terraform_state_bucket.name
}



