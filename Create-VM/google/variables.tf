variable "environment" {
  description = "Environment for the resources"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "The GCP region"
  type        = string
}

variable "gcp_zone" {
  description = "The GCP zone"
  type        = string
}

variable "machine_gcp" {
  description = "The machine type for the instances"
  type        = string
}

variable "image" {
  description = "The image to use for the instances"
  type        = string
}

variable "ssh_keys" {
  description = "The SSH public keys for instance access"
  type        = string
}
