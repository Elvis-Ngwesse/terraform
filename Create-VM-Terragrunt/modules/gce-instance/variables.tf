# ------------------------------------------------------
# Path to the Google Cloud service account credentials
# ------------------------------------------------------
variable "credentials_file" {
  description = "Path to the Google Cloud credentials JSON file"
  type        = string
  default = "../../gcp-key.json"
}

# --------------------------------------------
# Google Cloud project ID for resource creation
# --------------------------------------------
variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "new-devops-project-1"
}

# -----------------------------------------
# Region to deploy Google Cloud resources
# -----------------------------------------
variable "region" {
  description = "The region where resources will be deployed"
  type        = string
  default     = "europe-west2"
}

# ---------------------------------------------
# Zone to deploy the Compute Engine instance
# ---------------------------------------------
variable "zone" {
  description = "The zone where the compute instance will be deployed"
  type        = string
  default     = "europe-west2-a"
}

# --------------------------------------------------
# Name of the Compute Engine instance to create
# --------------------------------------------------
variable "instance_name" {
  description = "The name of the Compute Engine instance"
  type        = string
  default     = "example-instance"
}
