# AWS terraform.tfvars
machine = "t2.micro"
ssh_key_name = "my-ssh-key"
aws_region  = "eu-west-2"
environment = "dev"
ami_id      = "ami-0fbbcfb8985f9a341"
availability_zone = "eu-west-2a"



# GOOGLE terraform.tfvars
project_id = "new-devops-project-1"
gcp_region = "europe-west2"
gcp_zone = "europe-west2-a"
machine_gcp = "e2-micro"
image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
gcp_credentials_file = "./gcp-key.json"
ssh_key_file = "/Users/elvisngwesse/.ssh/id_kube_user_key.pub"