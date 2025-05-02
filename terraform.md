
# Configure AWS
- brew install awscli
- aws configure

# Configure Google
- brew install --cask google-cloud-sdk
- gcloud init
- gcloud auth login
- gcloud projects create new-devops-project-1 --name="New Devops Project-1"
- gcloud beta billing accounts list
- gcloud beta billing projects link new-devops-project-1 --billing-account 013D92-616728-DB3DF8
- gcloud config set project new-devops-project-1
- gcloud iam service-accounts create new-devops-service-account \
  --display-name "New DevOps Service Account"
- gcloud projects add-iam-policy-binding new-devops-project-1 \
  --member="serviceAccount:new-devops-service-account@new-devops-project-1.iam.gserviceaccount.com" \
  --role="roles/editor"
- gcloud iam service-accounts keys create gcp-key.json \
  --iam-account new-devops-service-account@new-devops-project-1.iam.gserviceaccount.com
- gcloud iam service-accounts list --project=new-devops-project-1
- gcloud services enable compute.googleapis.com storage.googleapis.com cloudfunctions.googleapis.com

# Terraform Installation
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- terraform -v

# Initialize Terraform
- terraform init
# Plan Terraform
- terraform plan -var-file="../../terraform.tfvars"
# Apply Configuration
- terraform apply -var-file="../../terraform.tfvars"
# Destroy Terraform
- terraform destroy -var-file="../../terraform.tfvars"

# Plan  IP Address Range
- Pick an IP range from the RFC 1918 private IP blocks, commonly used for internal networks
  10.0.0.0/8
  172.16.0.0/12
  192.168.0.0/16
  These are non-routable on the public internet and safe for internal use
- Avoid Overlaps
  Ensure the range you pick doesn't overlap with:
  Other subnets in your VPC
  On-prem networks (if you’re using hybrid connectivity like VPN or Interconnect)
- CIDR Size Selection
  Choose the CIDR block size based on expected usage:
  /24 = 256 IPs (usable ~251 after reservation) → Good for small subnets
  /16 = 65,536 IPs → Very large subnet, often overkill
  /28 = 16 IPs → Very small subnet, mostly for specialized cases
- Example
  Your VPC is 10.0.0.0/16
  Then:
    10.0.1.0/24 → for public subnet
    10.0.2.0/24 → for private subnet
    10.0.3.0/24 → reserved for future use