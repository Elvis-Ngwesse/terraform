# main.tf

# Env variables
locals {
  environment = var.environment
}

# Add AWS provider
provider "aws" {
  region = var.aws_region
}

# Create 3 EC2 instances using count
resource "aws_instance" "t2_micro_instance" {
  count             = 2
  ami               = var.ami_id
  instance_type     = var.machine
  availability_zone = var.availability_zone
  key_name          = var.ssh_key_name
  security_groups   = [aws_security_group.allow_ssh_and_ping.name]
  tags = {
    Name        = "instance-${count.index + 1}"
    Environment = local.environment
    Role        = "ubuntu-test"
  }

  # User data to configure the instance
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /home/ec2-user/hello.txt
              EOF
}

# Security group to allow SSH and Ping (ICMP)
resource "aws_security_group" "allow_ssh_and_ping" {
  name        = "allow-ssh-and-ping"
  description = "Allow SSH and Ping access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the instance IDs and public IPs
output "instance_ids_ips" {
  value = [
    for instance in aws_instance.t2_micro_instance : {
      id = instance.id
      ip = instance.public_ip
    }
  ]
  description = "The instance IDs and public IPs of the EC2 instances"
}
