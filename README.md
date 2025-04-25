# Region/Zone


# Email
- aws.gcp.devops.elvis@gmail.com

# Configure AWS
- brew install awscli
- aws configure

# Configure Google
- brew install --cask google-cloud-sdk
- gcloud init
- gcloud auth login
- gcloud projects create devops-project-elvis --name="DevOps Project Elvis"
- gcloud projects list
- gcloud auth revoke dopc02devops@gmail.com
- gcloud config set project devops-project-elvis
- gcloud billing accounts list
- gcloud billing projects link devops-project-elvis \
  --billing-account=013D92-616728-DB3DF8
- gcloud services enable compute.googleapis.com storage.googleapis.com cloudfunctions.googleapis.com

# Terraform Installation
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- terraform -v

# Terraform commands
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform destroy

# Add IAM Roles
gcloud projects add-iam-policy-binding devops-project-elvis \
  --member="user:aws.gcp.devops.elvis@gmail.com" \
  --role="roles/compute.securityAdmin"

gcloud projects add-iam-policy-binding devops-project-elvis \
  --member="user:aws.gcp.devops.elvis@gmail.com" \
  --role="roles/compute.networkAdmin"













    - To overide variables
      - terraform plan -var-file="dev.tfvars" -out="planfile"
      - terraform apply "planfile"
      - terraform destroy -var-file="dev.tfvars"
- Create pubblic key
    - ssh-keygen -t rsa -b 4096 -f ~/.ssh/[key-name]
- Login cli
    -  gcloud auth login
- Workspace
    - terraform workspace list
    - terraform workspace new dev
    - terraform workspace show
    - terraform workspace select test: test is the workspace to switch to
- terraform state list
- Create bucket
    - gsutil mb -p your-project-id -l europe-west2 gs://state-file-bucket
- Export credentials
    - export GOOGLE_APPLICATION_CREDENTIALS="~/gcp-account.json"
- Debugging
    - export env variable
      export TF_LOG=DEBUG
      export TF_LOG_PATH=terraform_debug.log
      terraform apply
    - log level
        - TRACE
        - DEBUG
        - INFO
        - WARN
        - ERROR
- Version install
    - brew install tfenv
    - tfenv -v
    - tfenv list-remote
    - tfenv install 1.10.1
    - Install multiple versions
    - tfenv use [version number]



# Create role
gcloud iam roles create firewallCreator \
  --project=devops-project-elvis \
  --title="Firewall Creator" \
  --description="Custom role to allow creating firewall rules" \
  --permissions="compute.firewalls.create,compute.firewalls.get,compute.firewalls.list" \
  --stage="GA"

gcloud projects add-iam-policy-binding devops-project-elvis \
  --member="serviceAccount:devops-project-elvis@appspot.gserviceaccount.com" \
  --role="projects/devops-project-elvis/roles/firewallCreator"
