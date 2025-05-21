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

# -----------------------------
# Create VPC (Virtual Private Cloud)
# -----------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"  # Define the CIDR block for the VPC
  enable_dns_support = true  # Enable DNS support in the VPC
  enable_dns_hostnames = true  # Enable DNS hostnames in the VPC
  tags = {
    Name        = "main-vpc"  # Set the Name tag for the VPC
    Environment = local.environment  # Tag with the environment value
  }
}

# -----------------------------
# Create a public subnet
# -----------------------------
resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id  # Attach the subnet to the main VPC
  cidr_block              = "10.0.1.0/24"  # Define the CIDR block for the public subnet
  availability_zone       = var.availability_zone  # Specify the availability zone
  map_public_ip_on_launch = true  # Ensure instances in the subnet get public IPs
  tags = {
    Name        = "main-public-subnet"  # Set the Name tag for the public subnet
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc]  # Ensure this depends on the VPC creation
}

# -----------------------------
# Create a private subnet
# -----------------------------
resource "aws_subnet" "main_private_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id  # Attach the subnet to the main VPC
  cidr_block              = "10.0.2.0/24"  # Define the CIDR block for the private subnet
  availability_zone       = var.availability_zone  # Specify the availability zone
  tags = {
    Name        = "main-private-subnet"  # Set the Name tag for the private subnet
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc]  # Ensure this depends on the VPC creation
}

# -----------------------------
# Create Internet Gateway (for public access to the internet)
# -----------------------------
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id  # Attach the internet gateway to the VPC
  tags = {
    Name        = "main-igw"  # Set the Name tag for the Internet Gateway
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc]  # Ensure this depends on the VPC creation
}

# -----------------------------
# Create Elastic IP for NAT Gateway
# -----------------------------
resource "aws_eip" "main_nat_eip" {
  vpc = true  # Allocate the Elastic IP for use in a VPC

  depends_on = [aws_vpc.main_vpc]  # Ensure this depends on the VPC creation
}

# -----------------------------
# Create NAT Gateway (allows private subnet instances to access the internet)
# -----------------------------
resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = aws_eip.main_nat_eip.id  # Use the previously created Elastic IP
  subnet_id     = aws_subnet.main_public_subnet.id  # Place the NAT gateway in the public subnet
  tags = {
    Name        = "main-nat-gateway"  # Set the Name tag for the NAT Gateway
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc, aws_eip.main_nat_eip]  # Ensure this depends on the VPC and EIP creation
}

# -----------------------------
# Create Route Table for Public Subnet
# -----------------------------
resource "aws_route_table" "main_public_route_table" {
  vpc_id = aws_vpc.main_vpc.id  # Attach the route table to the VPC

  # Define a route for outbound traffic to the internet via the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"  # Route all traffic to the internet
    gateway_id = aws_internet_gateway.main_igw.id  # Use the Internet Gateway
  }

  tags = {
    Name        = "main-public-route-table"  # Set the Name tag for the public route table
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc, aws_internet_gateway.main_igw]  # Ensure this depends on VPC and IGW creation
}

# -----------------------------
# Associate Route Table with Public Subnet
# -----------------------------
resource "aws_route_table_association" "main_public_route_table_assoc" {
  subnet_id      = aws_subnet.main_public_subnet.id  # Attach route table to public subnet
  route_table_id = aws_route_table.main_public_route_table.id  # Associate with the public route table

  depends_on = [aws_route_table.main_public_route_table, aws_subnet.main_public_subnet]  # Ensure this depends on route table and subnet
}

# -----------------------------
# Create Route Table for Private Subnet
# -----------------------------
resource "aws_route_table" "main_private_route_table" {
  vpc_id = aws_vpc.main_vpc.id  # Attach the route table to the VPC

  # Define a route for private subnet traffic to the internet via the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"  # Route all traffic to the internet
    nat_gateway_id = aws_nat_gateway.main_nat_gateway.id  # Use the NAT Gateway
  }

  tags = {
    Name        = "main-private-route-table"  # Set the Name tag for the private route table
    Environment = local.environment  # Tag with the environment value
  }

  depends_on = [aws_vpc.main_vpc, aws_nat_gateway.main_nat_gateway]  # Ensure this depends on VPC and NAT Gateway creation
}

# -----------------------------
# Associate Route Table with Private Subnet
# -----------------------------
resource "aws_route_table_association" "main_private_route_table_assoc" {
  subnet_id      = aws_subnet.main_private_subnet.id  # Attach route table to private subnet
  route_table_id = aws_route_table.main_private_route_table.id  # Associate with the private route table

  depends_on = [aws_route_table.main_private_route_table, aws_subnet.main_private_subnet]  # Ensure this depends on route table and subnet
}

# -----------------------------
# Create EC2 Instance in Public Subnet
# -----------------------------
resource "aws_instance" "t2_micro_public_instance" {
  count             = 2  # Launch one instance
  ami               = var.ami_id  # AMI to use for the instance
  instance_type     = var.machine  # Instance type (e.g., t2.micro)
  availability_zone = var.availability_zone  # AZ in which to launch the instance
  key_name          = var.ssh_key_name  # SSH key for access
  subnet_id         = aws_subnet.main_public_subnet.id  # Place instance in public subnet
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_ping.id]  # Use security group by ID

  associate_public_ip_address = true  # Ensure instance gets a public IP

  tags = {
    Name        = "public-instance-${count.index + 1}"  # Tag the instance with a name
    Environment = local.environment  # Add environment tag
    Role        = "ubuntu-test"  # Custom role tag
    ansible-managed = "true"
  }

  # User data script to run on instance boot
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Public Instance" > /home/ec2-user/hello.txt
              EOF

  depends_on = [aws_vpc.main_vpc, aws_subnet.main_public_subnet, aws_security_group.allow_ssh_and_ping]  # Ensure instance depends on VPC, subnet, and security group
}

# -----------------------------
# Create EC2 Instance in Private Subnet
# -----------------------------
resource "aws_instance" "t2_micro_private_instance" {
  count             = 1  # Number of instances to create
  ami               = var.ami_id  # Specify the AMI ID for the instance
  instance_type     = var.machine  # Specify the instance type
  availability_zone = var.availability_zone  # Specify the availability zone
  key_name          = var.ssh_key_name  # Specify the SSH key name for access
  subnet_id         = aws_subnet.main_private_subnet.id  # Place the instance in the private subnet
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_ping.id]  # Attach the security group for SSH and ping
  tags = {
    Name        = "private-instance-${count.index + 1}"  # Tag the instance with a unique name
    Environment = local.environment  # Tag with the environment value
    Role        = "ubuntu-test"  # Tag with the role of the instance
  }

  # User data to configure the instance on launch
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /home/ec2-user/hello.txt
              EOF

  depends_on = [aws_vpc.main_vpc, aws_subnet.main_private_subnet, aws_security_group.allow_ssh_and_ping]  # Ensure instance depends on VPC, subnet, and security group
}

# -----------------------------
# Security group to allow SSH and Ping (ICMP)
# -----------------------------
resource "aws_security_group" "allow_ssh_and_ping" {
  name        = "allow-ssh-and-ping"  # Set the name for the security group
  description = "Allow SSH and Ping access"  # Description of the security group
  vpc_id      = aws_vpc.main_vpc.id  # Attach the security group to the VPC

  ingress {
    from_port   = 22  # Allow SSH access on port 22
    to_port     = 22  # Allow SSH access on port 22
    protocol    = "tcp"  # Use the TCP protocol
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (can be restricted to specific IPs)
  }

  ingress {
    from_port   = 80
    to_port     = 90
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1  # Allow all ICMP (Ping) traffic
    to_port     = -1  # Allow all ICMP (Ping) traffic
    protocol    = "icmp"  # ICMP protocol
    cidr_blocks = ["0.0.0.0/0"]  # Allow Ping from anywhere
  }

  egress {
    from_port   = 0  # Allow all outgoing traffic
    to_port     = 0  # Allow all outgoing traffic
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to any destination
  }

  depends_on = [aws_vpc.main_vpc]  # Ensure security group depends on VPC creation
}

# -----------------------------
# Output EC2 Instance Info from Public Subnet
# -----------------------------
output "public_instance_ips" {
  value = [
    for instance in aws_instance.t2_micro_public_instance : {
      id          = instance.id  # Instance ID
      private_ip  = instance.private_ip  # Private IP address
      public_ip   = instance.public_ip  # Public IP address (assigned automatically)
    }
  ]
  description = "Public subnet EC2 instance IPs"  # Describe the output
}

# -----------------------------
# Output EC2 Instance Info from Private Subnet
# -----------------------------
output "private_instance_ips" {
  value = [
    for instance in aws_instance.t2_micro_private_instance : {
      id          = instance.id        # Instance ID
      private_ip  = instance.private_ip  # Private IP address of the instance
      public_ip   = instance.public_ip   # Public IP address (if assigned, but won't be assigned in private subnet)
    }
  ]
  description = "Private subnet EC2 instance IPs"  # Description of the output
}

# -----------------------------
# Output EC2
