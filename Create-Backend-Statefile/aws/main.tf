# -----------------------------
# Add AWS provider
# -----------------------------
provider "aws" {
  region = "eu-west-2"
}

# -----------------------------
# Data source: Get default subnet in default VPC
# -----------------------------
data "aws_subnet" "default" {
  default_for_az     = true
  availability_zone  = "eu-west-2a"  # You can change to 2b or 2c as needed
}

# -----------------------------
# Create EC2 instance in default VPC
# -----------------------------
resource "aws_instance" "example" {
  ami                    = "ami-0fbbcfb8985f9a341"  # Valid AMI for Amazon Linux 2 in eu-west-2
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.default.id
  associate_public_ip_address = true

  tags = {
    Name = "TerraformExampleInstance"
  }
}

# -----------------------------
# Output public IP of the EC2 instance
# -----------------------------
output "instance_public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}
