
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
- terraform plan -var-file="../../terraform.tfvars"

# Apply Configuration
- terraform apply -var-file=".../../terraform.tfvars"
- terraform destroy -var-file="../../terraform.tfvars"
