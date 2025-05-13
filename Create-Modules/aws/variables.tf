# -----------------------------
# Environment and Region Variables
# -----------------------------

# The environment where the infrastructure is deployed (e.g., dev, prod)
variable "environment" {
  description = "The environment to deploy resources (e.g., dev, prod)"
  type        = string
}

# AWS region to deploy the resources
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}