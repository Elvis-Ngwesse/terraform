# -----------------------------
# main.tf
# -----------------------------

# -----------------------------
# Data source to fetch the default VPC
# -----------------------------
data "aws_vpc" "default" {
  default = true
}

# -----------------------------
# Data source to fetch subnet IDs from the default VPC
# -----------------------------
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -----------------------------
# Security Group for HTTP traffic (Port 80)
# -----------------------------
resource "aws_security_group" "web_sg" {
  name_prefix = "apache-web-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# EC2 instance for Apache Web Server
# -----------------------------
resource "aws_instance" "web_server_apache" {
  ami               = var.ami_id
  instance_type     = var.machine
  key_name          = var.ssh_key_name
  subnet_id         = data.aws_subnets.default.ids[0]

  # Instance tags
  tags = {
    Name = var.apache_server_name
  }

  # User data for installing and starting Apache
  user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
  EOT

  vpc_security_group_ids = [aws_security_group.web_sg.id]  # ✅ Fixed here

  associate_public_ip_address = true

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}
