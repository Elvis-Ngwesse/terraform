
# -----------------------------
# AWS Region
# -----------------------------
variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"  # Adjust the default region if needed
}

# -----------------------------
# Environment
# -----------------------------
variable "environment" {
  description = "The environment (e.g., production, dev)."
  type        = string
}

# -----------------------------
# Lambda Function Handler
# -----------------------------
variable "lambda_handler" {
  description = "The handler for the Lambda function."
  type        = string
  default     = "main.lambda_handler"  # Change as per your function's handler
}

# -----------------------------
# Lambda Runtime
# -----------------------------
variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.10"  # Change to the version you need
}

# -----------------------------
# S3 Bucket Prefix
# -----------------------------
variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket name."
  type        = string
  default     = "bucket"
}

# -----------------------------
# S3 Bucket Name
# -----------------------------
variable "bucket_name_tag" {
  description = "S3 bucket name tag"
  type        = string
  default     = "lambda-function-bucket"
}

# -----------------------------
# Lambda Function ZIP File Path
# -----------------------------
variable "function_zip_file" {
  description = "The path to the Lambda function zip file."
  type        = string
  default     = "function.zip"
}

# -----------------------------
# Lambda Layer ZIP File Path
# -----------------------------
variable "flask_layer_zip_file" {
  description = "Path to the Flask Lambda Layer ZIP file"
  type        = string
  default     = "flask_layer.zip"
}
# -----------------------------
# IAM Role Name
# -----------------------------
variable "lambda_exec_role_name" {
  description = "The name of the IAM role for Lambda execution."
  type        = string
  default     = "lambda_exec_role"
}
