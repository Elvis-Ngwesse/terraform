# -------------------------------------------------------------
# AWS terraform.tfvars: AWS specific variables
# -------------------------------------------------------------
machine              = "t2.micro"                             # Instance type for AWS EC2
ssh_key_name         = "my-ssh-key"                          # Name of the SSH key for accessing the EC2 instance
aws_region           = "eu-west-2"                            # AWS region where resources will be created
environment          = "dev"                                  # The environment type (e.g., dev, prod)
ami_id               = "ami-0fbbcfb8985f9a341"               # The Amazon Machine Image (AMI) ID to use
availability_zone    = "eu-west-2a"                           # Availability zone within the specified AWS region

# -------------------------------------------------------------
# GOOGLE terraform.tfvars: Google Cloud specific variables
# -------------------------------------------------------------
project_id           = "new-devops-project-1"                # Google Cloud project ID
gcp_region           = "europe-west2"                         # GCP region where resources will be created
gcp_zone             = "europe-west2-a"                       # Specific availability zone within GCP region
machine_gcp          = "e2-micro"                             # Google Cloud machine type for the instance
image                = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts" # GCP image to use for the instance
gcp_credentials_file = "../../gcp-key.json"                  # Path to the GCP credentials file for authentication
