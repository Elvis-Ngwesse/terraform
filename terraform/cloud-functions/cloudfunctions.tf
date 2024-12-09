

# Add provider
provider "google" {
  credentials = file("../../gcp-account.json")
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}


# Generate a random string for the bucket name
resource "random_string" "bucket_name" {
  length  = 16  # Adjust length as needed
  special = false  # Set to true if you want special characters
  upper   = false  # Set to true if you want uppercase characters
}

resource "google_storage_bucket" "function_bucket" {
  name                        = "bucket-${random_string.bucket_name.result}"
  location                    = "europe-west2"
  lifecycle {
    prevent_destroy = false
  }
}

# Upload function code as a zip file
resource "google_storage_bucket_object" "function_zip" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "function.zip"  # Path to your zipped function code
}

# Deploy Cloud Function
resource "google_cloudfunctions_function" "put_function" {
  name        = "put_api_function"
  runtime     = "python310"
  trigger_http = true
  entry_point = "update_data"

  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name

  environment_variables = {
    ENV = "production"
  }
}


output "function_url" {
  value = google_cloudfunctions_function.put_function.https_trigger_url
}

#----------Enable api----------
#gcloud services enable cloudfunctions.googleapis.com
#gcloud services enable cloudbuild.googleapis.com
#gcloud services enable storage.googleapis.com
#gcloud services list --enabled

#----------Zip code----------
# zip function.zip main.py requirements.txt

#----------Grant access to function----------
#gcloud functions add-iam-policy-binding put_api_function \
#--region europe-west2 \
#--member="allUsers" \
#--role="roles/cloudfunctions.invoker"

#----------Make curl request----------
#curl -X PUT -H "Content-Type: application/json" \
#-d '{"id": 123, "name": "Test Data"}' \
#https://europe-west2-superb-gear-443409-t3.cloudfunctions.net/put_api_function

