
#In GCP, fine-grained access control allows you to manage access to individual
#objects within a bucket using both IAM policies and Object Access Control Lists (ACLs).
#This is useful when you need more granular control over who can access specific files or
#data within a bucket.



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
  name          = "tf-${random_string.bucket_name.result}"
  location      = "europe-west2"
  force_destroy = true

  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }

  retention_policy {
    is_locked    = false
    retention_period = 1
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_storage_bucket_object" "object_level_acl" {
  name   = "myfile"
  bucket = google_storage_bucket.my_terraform_state_bucket.name
  source = "./myfile.txt"
}

resource "google_storage_object_access_control" "object_acl" {
  bucket = google_storage_bucket.my_terraform_state_bucket.name
  object = google_storage_bucket_object.object_level_acl.name
  role   = "READER"
  entity = "user-dopc02devops1@gmail.com" # Grant access to a specific user
}



output "bucket_name" {
  value = google_storage_bucket.my_terraform_state_bucket.name
}

#gcloud projects add-iam-policy-binding superb-gear-443409-t3 \
#--member="user:dopc02devops1@gmail.com" \
#--role="roles/storage.objectViewer"


#gcloud storage buckets add-iam-policy-binding gs://tf-et9fe39rpshqzcd3 \
#--member="user:dopc02devops@gmail.com" \
#--role="roles/storage.admin"

#gcloud projects add-iam-policy-binding superb-gear-443409-t3 \
#--member="user:dopc02devops@gmail.com" \
#--role="roles/owner"

#gcloud projects get-iam-policy superb-gear-443409-t3
#gsutil iam get gs://your-bucket-name
