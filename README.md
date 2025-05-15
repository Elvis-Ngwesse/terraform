

python3 -m venv venv
source venv/bin/activate

# Email
- aws.gcp.devops.elvis@gmail.com

# Terraform Installation
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- terraform -v

- Create pubblic key
    - ssh-keygen -t rsa -b 4096 -f ~/.ssh/[key-name]
- Login cli
    -  gcloud auth login
- Workspace
    - terraform workspace list
    - terraform workspace new dev
    - terraform workspace show
    - terraform workspace select test: test is the workspace to switch to
- Export credentials
    - export GOOGLE_APPLICATION_CREDENTIALS="~/gcp-account.json"


    
