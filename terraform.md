# ☁️ Cloud DevOps Setup Guide

## ✅ AWS CLI Setup
```bash
brew install awscli
aws configure

🌐 Google Cloud SDK Setup
brew install --cask google-cloud-sdk
gcloud init
gcloud auth login

🚀 Create a New Project
gcloud projects create new-devops-project-1 --name="New Devops Project-1"

💳 Link Billing
gcloud beta billing accounts list
gcloud beta billing projects link new-devops-project-1 --billing-account 013D92-616728-DB3DF8

🔧 Set Active Project
gcloud config set project new-devops-project-1

👤 Create and Configure Service Account
gcloud iam service-accounts create new-devops-service-account \
  --display-name "New DevOps Service Account"
gcloud projects add-iam-policy-binding new-devops-project-1 \
  --member="serviceAccount:new-devops-service-account@new-devops-project-1.iam.gserviceaccount.com" \
  --role="roles/editor"
gcloud iam service-accounts keys create gcp-key.json \
  --iam-account new-devops-service-account@new-devops-project-1.iam.gserviceaccount.com
gcloud iam service-accounts list --project=new-devops-project-1

📦 Enable Required Services
gcloud services enable \
  compute.googleapis.com \
  storage.googleapis.com \
  cloudfunctions.googleapis.com
  
🌍 IP Address Planning (RFC 1918)
📌 Private IP Ranges
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
These are safe for internal use and are not routable on the public internet.

🚫 Avoid Overlaps
Ensure no conflict with:
Existing VPC subnets
On-prem networks (VPN or Interconnect)

📐 Choose Appropriate CIDR Size
CIDR Block	Usable IPs	Use Case
/28	~11	Specialized/small resources
/24	~251	Common small subnets
/16	~65,531	Very large, usually overkill
Example Subnet Plan for VPC 10.0.0.0/16:
10.0.1.0/24 → Public Subnet
10.0.2.0/24 → Private Subnet
10.0.3.0/24 → Reserved

⚙️ Terraform Setup
📥 Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform -v

🔧 Initialize & Use Terraform
terraform init
terraform plan -var-file="../../terraform.tfvars"
terraform apply -var-file="../../terraform.tfvars"
terraform destroy -var-file="../../terraform.tfvars"


