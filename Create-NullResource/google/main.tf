# -----------------------------
# Set environment as a local variable
# -----------------------------
locals {
  environment            = var.environment
  bucket_name_prefix     = "bucket"
  bucket_location        = var.bucket_location
  function_zip_file      = var.function_zip_file
  function_name          = var.function_name
  function_entry_point   = var.function_entry_point
  function_runtime       = var.function_runtime
  env_var                = var.environment
}

# -----------------------------
# Configure GCP Provider
# -----------------------------
provider "google" {
  credentials = file(var.gcp_credentials_file)
  project     = var.project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

# -----------------------------
# Generate a random string for the bucket name
# -----------------------------
resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

# -----------------------------
# Create a Google Cloud Storage bucket
# -----------------------------
resource "google_storage_bucket" "function_bucket" {
  name     = "${local.bucket_name_prefix}-${random_string.bucket_name.result}"
  location = local.bucket_location

  lifecycle {
    prevent_destroy = false
  }
}

# -----------------------------
# Upload function code as a zip file
# -----------------------------
resource "google_storage_bucket_object" "function_zip" {
  name   = local.function_zip_file
  bucket = google_storage_bucket.function_bucket.name
  source = local.function_zip_file
}

# -----------------------------
# Deploy Cloud Function
# -----------------------------
resource "google_cloudfunctions_function" "put_function" {
  name                    = local.function_name
  runtime                 = local.function_runtime
  trigger_http            = true
  entry_point             = local.function_entry_point
  source_archive_bucket   = google_storage_bucket.function_bucket.name
  source_archive_object   = google_storage_bucket_object.function_zip.name

  environment_variables = {
    ENV = local.env_var
  }
}

# -----------------------------
# Create a null resource to run a post-deployment script and trigger the API (Cloud Function URL)
# -----------------------------
resource "null_resource" "post_deployment_script" {
  provisioner "local-exec" {
    command = <<EOT
    echo "Cloud Function deployment completed!"
    echo "Cloud Function URL: ${google_cloudfunctions_function.put_function.https_trigger_url}"

    # Trigger the Cloud Function using curl (PUT request)
    curl -X PUT -H "Content-Type: application/json" \
    -d '{"id": 123212, "name": "Testing"}' \
    "${google_cloudfunctions_function.put_function.https_trigger_url}"

    echo "API call to Cloud Function completed!"
    echo "Post-deployment tasks completed!"
    EOT
  }

  # Trigger this resource to run after the Cloud Function is created
  depends_on = [
    google_cloudfunctions_function.put_function
  ]

  # Use a trigger to always run this when `terraform apply` is called
  triggers = {
    always_run = timestamp()
  }
}

# -----------------------------
# Output the Cloud Function URL
# -----------------------------
output "function_url" {
  value = google_cloudfunctions_function.put_function.https_trigger_url
}
