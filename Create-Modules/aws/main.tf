# -----------------------------
# Env variables
# -----------------------------
locals {
  environment = var.environment  # Set the environment variable from the user input
}

# -----------------------------
# Add AWS provider
# -----------------------------
provider "aws" {
  region = var.aws_region  # Specify the AWS region to deploy resources
}


module "apache" {
  source = "./apache_module"
  ami_id = "ami-0fbbcfb8985f9a341"
  ssh_key_name = "my-ssh-key"
}
