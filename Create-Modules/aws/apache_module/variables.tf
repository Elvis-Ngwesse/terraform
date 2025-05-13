# -----------------------------
# AMI ID for the EC2 instance
# -----------------------------
variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

# -----------------------------
# EC2 instance type
# -----------------------------
variable "machine" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# -----------------------------
# SSH key pair name
# -----------------------------
variable "ssh_key_name" {
  description = "SSH key name to use for the EC2 instance"
  type        = string
}

# -----------------------------
# Apache server name tag
# -----------------------------
variable "apache_server_name" {
  description = "Name tag for the Apache web server instance"
  type        = string
  default     = "apache-web-server"
}
