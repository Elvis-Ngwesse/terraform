

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

    
