# -----------------------------
# Google Cloud Platform Configuration Variables
# -----------------------------

# -----------------------------
# The Google Cloud Platform project ID
# -----------------------------
variable "project_id" {
  description = "The Google Cloud Platform project ID"
  type        = string
}

# -----------------------------
# The GCP region to deploy resources in
# -----------------------------
variable "gcp_region" {
  description = "The GCP region to deploy resources in"
  type        = string
}

# -----------------------------
# The GCP zone to deploy resources in
# -----------------------------
variable "gcp_zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
}

# -----------------------------
# Path to the service account credentials file (JSON format)
# -----------------------------
variable "gcp_credentials_file" {
  description = "Path to the service account credentials file (JSON format)"
  type        = string
  sensitive   = true
}
