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
  default     = "us-west-2"  # Default region if not specified
}

# The AWS availability zone for the subnets
variable "availability_zone" {
  description = "The AWS availability zone for the subnets"
  type        = string
}

# -----------------------------
# EC2 Instance Variables
# -----------------------------

# AMI ID to use for the EC2 instance
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

# Instance type for the EC2 instance
variable "machine" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"  # Default to a small instance type
}

# SSH key pair name for accessing EC2 instances
variable "ssh_key_name" {
  description = "The SSH key pair name for accessing EC2 instances"
  type        = string
}

# -----------------------------
# Networking and Security Variables
# -----------------------------

# The CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Example CIDR block for the VPC
}

# The CIDR block for the public subnet
variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"  # Example CIDR block for the public subnet
}

# The CIDR block for the private subnet
variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"  # Example CIDR block for the private subnet
}

# The ID of the security group for the EC2 instance
variable "security_group_id" {
  description = "The ID of the security group for the EC2 instance"
  type        = string
}
