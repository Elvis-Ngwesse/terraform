# -----------------------------
# GCP Environment Variables
# -----------------------------

# Specifies the deployment environment (e.g., dev, prod)
variable "environment" {
  description = "Specifies the deployment environment (e.g., dev, prod)"
  type        = string
}

# The Google Cloud Platform project ID
variable "project_id" {
  description = "The Google Cloud Platform project ID"
  type        = string
}

# The GCP region to deploy resources in
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
}

# The GCP zone to deploy resources in
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
}

# -----------------------------
# GCP Credentials and Function Configuration
# -----------------------------

# Path to the service account credentials file (JSON format)
variable "gcp_credentials_file" {
  description = "Path to the service account credentials file (JSON format)"
  type        = string
  sensitive   = true
}

# Location for the Cloud Storage bucket (default: europe-west2)
variable "bucket_location" {
  description = "Location for the Cloud Storage bucket"
  type        = string
  default     = "europe-west2"
}

# Path to the zipped Cloud Function source code
variable "function_zip_file" {
  description = "Path to the zipped Cloud Function source code"
  type        = string
  default     = "function.zip"
}

# Name of the Cloud Function
variable "function_name" {
  description = "Name of the Cloud Function"
  type        = string
  default     = "put_api_function"
}

# The name of the function to execute within the source code
variable "function_entry_point" {
  description = "The name of the function to execute within the source code"
  type        = string
  default     = "update_data"
}

# Runtime environment for the Cloud Function (e.g., python310)
variable "function_runtime" {
  description = "Runtime environment for the Cloud Function (e.g., python310)"
  type        = string
  default     = "python310"
}
