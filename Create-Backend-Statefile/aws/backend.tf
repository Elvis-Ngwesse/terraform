# ----------------------------------------------
# Terraform Backend Configuration (S3)
# ----------------------------------------------
terraform {
  backend "s3" {
    bucket         = "my-devops-terraform-bucket-1-20230514"  # Your S3 bucket name
    key            = "terraform.tfstate"                        # Path for the state file in the bucket
    region         = "eu-west-2"                                 # Region where your bucket is located
    encrypt        = true                                        # Enable encryption
    dynamodb_table = "my-terraform-lock-table"                   # DynamoDB table for state locking
    acl            = "private"                                   # Set the ACL for the state file (private recommended)
  }
}
