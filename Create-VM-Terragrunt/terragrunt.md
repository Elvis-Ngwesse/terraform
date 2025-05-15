
├── terraform/
│   ├── gcp-key.json                                   <-- your GCP credentials
│   └── Create-VM-Terragrunt/
│       ├── modules/                                   <-- Terraform modules directory
│       │   └── gce-instance/
│       │       ├── main.tf                            <-- GCE instance resource definition
│       │       └── variables.tf                       <-- Input variables for the module
│       │
│       ├── live/                                      <-- Environment configurations
│       │   ├── config.hcl                             <-- Shared Terragrunt configuration
│       │   ├── prod/
│       │   │   └── gce-instance/
│       │   │       └── terragrunt.hcl                 <-- Terragrunt config for prod
│       │   └── dev/
│       │       └── gce-instance/
│       │           └── terragrunt.hcl                 <-- Terragrunt config for dev



1. Define the GCE Instance Module
   First, we need to create the module that will define the resources we want to provision (in this case, a Google Compute Engine instance).

2. Create Terragrunt Configuration for Each Environment
   Next, we will create a Terragrunt configuration in each environment folder (dev, prod) to configure the settings that apply to each environment.
3. Terragrunt Configuration for Environment Reusability
   If you want to manage common configurations like the provider (credentials, project, etc.) across all environments, 
you can create a terragrunt.hcl file in a root folder (live) to include common

Run Terragrunt Commands
Once you have everything set up, you can use Terragrunt to manage and deploy the infrastructure across environments.

cd live/dev/gce-instance
cd live/prod/gce-instance
terragrunt apply
terragrunt run-all destroy

gsutil mb -l europe-west2 gs://my-devops-terraform-bucket-2-20230514/
gsutil versioning set on gs://my-devops-terraform-bucket-2-20230514

gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514
gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514/* && gsutil rb gs://my-devops-terraform-bucket-2-20230514/

