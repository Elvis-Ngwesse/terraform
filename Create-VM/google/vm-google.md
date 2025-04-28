
# Configure Google
- brew install --cask google-cloud-sdk
- gcloud init
- gcloud auth login
- gcloud config set project ecstatic-maxim-457703-f8
- gcloud services enable compute.googleapis.com storage.googleapis.com cloudfunctions.googleapis.com

# Terraform commands
- terraform init
- terraform plan -var-file="../../terraform.tfvars"
# Apply Configuration
- terraform apply -var-file="../../terraform.tfvars"
- terraform destroy -var-file="../../terraform.tfvars"





gcloud projects add-iam-policy-binding devops-project-ts \
--member="serviceAccount:devops-service-account@devops-project-ts.iam.gserviceaccount.com" \
--role="roles/resourcemanager.projectIamAdmin"


gcloud projects add-iam-policy-binding devops-project-ts \
--member="serviceAccount:aws.gcp.devops.elvis@gmail.com" \
--role="roles/serviceusage.serviceUsageConsumer"
