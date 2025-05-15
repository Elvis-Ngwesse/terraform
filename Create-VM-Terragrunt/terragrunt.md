

infrastructure/
├── live/
│   ├── dev/
│   │   ├── gce-instance/
│   ├── prod/
│   │   ├── gce-instance/
└── modules/
└── gce-instance/


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
terragrunt apply

gsutil mb -l europe-west2 gs://my-devops-terraform-bucket-2-20230514/
gsutil versioning set on gs://your-terraform-state-bucket/
gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514
gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514/* && gsutil rb gs://my-devops-terraform-bucket-2-20230514/

