# variables.tf

# Variable for the EC2 instance machine type
variable "machine" {
  description = "The EC2 instance machine type"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the EC2 instance"
  type        = string
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
}

# Variable for environment name
variable "environment" {
  description = "Environment for the resources"
  type        = string
}

# Variable for the AMI ID used for EC2 instances
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}
