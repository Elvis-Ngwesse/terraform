# variables.tf

# Variable for the EC2 instance machine type and availability zone
variable "machine" {
  description = "Configuration for the EC2 instance machine"
  type = object({
    machine_type = string
    zone         = string
  })
}

# Variable for the SSH key name to access EC2 instances
variable "ssh_key_name" {
  description = "The SSH key name to access the EC2 instances"
  type        = string
}

# Variable for the AWS region
variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "eu-west-2"
}

# Variable for environment name (default is dev)
variable "environment" {
  description = "Environment for the resources"
  type        = string
  default     = "dev"
}

# Variable for the AMI ID used for EC2 instances
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
  default     = "ami-0fbbcfb8985f9a341"
}
