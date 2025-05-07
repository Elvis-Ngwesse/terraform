## AWS
# Create ssh-key #
- Create key from cli:
    aws ec2 create-key-pair --key-name my-ssh-key --query "KeyMaterial" --output text > my-ssh-key.pem

# IAM Policies AWS
- Give User readonly access policy:
    aws iam attach-user-policy --user-name aws-elvis --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# Login to VM's
chmod 400 my-ssh-key.pem
ssh -i my-ssh-key.pem ec2-user@<public-ip>

# Cidre-Block
- vpc cidr_block = "10.0.0.0/16" defines the entire IP range of your VPC — basically, the big network in which all 
    your subnets live
  - Public Subnet = "10.0.1.0/24" A smaller network that allows access to and from the internet (typically via an 
  internet gateway)
  - Private Subnet "10.0.2.0/24" Another smaller network but isolated from direct internet access, used for things like 
  databases or internal services

# Why this is structured this way:
- VPC (10.0.0.0/16): Gives you up to 65,536 IP addresses, allowing you to divide them among multiple subnets
- Subnets (/24): Each /24 gives 256 IP
  - For a /24 network:
  - 32 − 24 = 8 32−24=8 bits are available for hosts
  - So the number of possible addresses is:
  - 2 8th =256 total IPs.
# Separation of concerns:
- Public subnet (10.0.1.0/24) — for EC2 instances, load balancers, etc. that need internet access
- Private subnet (10.0.2.0/24) — for RDS, app servers, etc. that should not be exposed to the internet directly

This setup is foundational for designing secure, scalable cloud infrastructure in AWS.