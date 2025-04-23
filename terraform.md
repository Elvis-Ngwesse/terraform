# Terraform
Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or optionally JSON.

Terraform lets you write code to describe the infrastructure you need — like servers, databases, networks, or cloud services — and then automatically sets it up for you.

# Core Concepts
- Providers: These are the services Terraform can interact with AWS, Azure, GCP, Kubernetes
- Resources: These are the components you want to create/manage (like an EC2 instance, an S3 bucket, etc.)
- Modules: Packages of reusable Terraform code.
- State: Terraform keeps track of what it’s managing using a state file (terraform.tfstate).
- Plan and Apply: You use terraform plan to preview changes and terraform apply to execute them.

# Create virtual env
    # install python
    # python3 -m venv venv
    # source venv/bin/activate
    # pip3 install -r src/requirements.txt
    # pip3 freeze > src/requirements.txt 
        # Only do this if requirements.txt is empty
        # First install al dependencies then run pip freeze command
