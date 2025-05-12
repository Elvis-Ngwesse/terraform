# -----------------------------
# GCP Environment Variables
# -----------------------------

# Environment for the resources (e.g., dev, prod)
variable "environment" {
  description = "Environment for the resources (e.g., dev, prod)"
  type        = string
}

# The GCP project ID
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

# The GCP region for the resources
variable "gcp_region" {
  description = "The GCP region"
  type        = string
}

# The GCP zone where the resources will be deployed
variable "gcp_zone" {
  description = "The GCP zone"
  type        = string
}

# -----------------------------
# GCP Compute Instance Variables
# -----------------------------

# The machine type for the instances
variable "machine_gcp" {
  description = "The machine type for the instances (e.g., e2-medium, n1-standard-1)"
  type        = string
}

# The image to use for the instances
variable "image" {
  description = "The image to use for the instances (e.g., ubuntu-2004-lts)"
  type        = string
}

# -----------------------------
# GCP Credentials Variables
# -----------------------------

# Path to the Google Cloud credentials JSON file (for authentication)
variable "gcp_credentials_file" {
  description = "Path to the Google Cloud credentials JSON file"
  type        = string
  sensitive   = true  # This ensures the credentials are not displayed in logs
}
