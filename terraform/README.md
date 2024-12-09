

- Initi terraform file
    - brew tap hashicorp/tap                     
      brew install hashicorp/tap/terraform
    - brew install --cask google-cloud-sdk
    - run
      - gcloud auth application-default login
    - terraform init
    - terraform validate
    - terraform plan
    - terraform apply
    - terraform destroy
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

