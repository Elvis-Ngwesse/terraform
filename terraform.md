# Terraform
Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or optionally JSON.

Terraform lets you write code to describe the infrastructure you need — like servers, databases, networks, or cloud services — and then automatically sets it up for you.

# Core Concepts
- Providers: These are the services Terraform can interact with AWS, Azure, GCP, Kubernetes
- Resources: These are the components you want to create/manage (like an EC2 instance, an S3 bucket, etc.)
- Modules: Packages of reusable Terraform code.
- State: Terraform keeps track of what it’s managing using a state file (terraform.tfstate).
- Plan and Apply: You use terraform plan to preview changes and terraform apply to execute them.

# Configure AWS
- brew install awscli
- aws configure

# Terraform Installation
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- terraform -v

# Initialize Terraform
- terraform init
- terraform plan -var-file="../terraform.tfvars"
# Apply Configuration
- terraform apply
- terraform apply -var-file="../terraform.tfvars"
- terraform destroy -var-file="../terraform.tfvars"
