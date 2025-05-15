├── terraform/
│   ├── gcp-key.json                                   <-- GCP credentials file for authentication with Google Cloud Platform
│   └── Create-VM-Terragrunt/
│       ├── modules/                                   <-- Directory for reusable Terraform modules
│       │   └── gce-instance/
│       │       ├── main.tf                            <-- Terraform code to define Google Compute Engine (GCE) instance resource
│       │       └── variables.tf                       <-- Input variables for the gce-instance module
│       │
│       ├── live/                                      <-- Directory containing environment-specific configurations
│       │   ├── config.hcl                             <-- Shared Terragrunt configuration for common settings across environments
│       │   ├── prod/
│       │   │   └── gce-instance/
│       │   │       └── terragrunt.hcl                 <-- Terragrunt configuration specific to the prod environment
│       │   └── dev/
│       │       └── gce-instance/
│       │           └── terragrunt.hcl                 <-- Terragrunt configuration specific to the dev environment

# --------------------------------------------
# Run Terragrunt Commands
# --------------------------------------------
# Navigate to the dev environment and apply the Terragrunt configuration to create resources
cd live/dev/gce-instance
terragrunt apply   # Apply Terragrunt configuration for the dev environment

# Navigate to the prod environment and apply the Terragrunt configuration to create resources
cd live/prod/gce-instance
terragrunt apply   # Apply Terragrunt configuration for the prod environment

# Destroy all resources in all environments (be careful with this command)
terragrunt run-all destroy   # Destroy resources across all environments

# --------------------------------------------
# Create and Configure Google Cloud Storage Bucket
# --------------------------------------------
# Create a Google Cloud Storage bucket in the Europe-west2 region
gsutil mb -l europe-west2 gs://my-devops-terraform-bucket-2-20230514/

# Enable versioning on the bucket for better data management
gsutil versioning set on gs://my-devops-terraform-bucket-2-20230514

# --------------------------------------------
# Clean Up and Delete Bucket
# --------------------------------------------
# Delete all objects from the bucket and then remove the bucket itself
gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514
gsutil -m rm -r gs://my-devops-terraform-bucket-2-20230514/* && gsutil rb gs://my-devops-terraform-bucket-2-20230514/

# --------------------------------------------
# Terragrunt Configuration for Environment Reusability
# --------------------------------------------
# To centralize common configurations, you can create a terragrunt.hcl file in the root folder (live/)
# and include shared settings such as provider configurations (e.g., credentials, project).
# This allows for easier maintenance and reusability across different environments like dev and prod.
