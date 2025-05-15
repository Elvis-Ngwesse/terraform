# -----------------------------
# STEP 1: Create an S3 Bucket for Terraform State Storage
# -----------------------------
aws s3api create-bucket \
--bucket my-devops-terraform-bucket-1-20230514 \
--region eu-west-2 \
--create-bucket-configuration LocationConstraint=eu-west-2

# -----------------------------
# STEP 2: Enable Versioning on the S3 Bucket
# -----------------------------
aws s3api put-bucket-versioning \
--bucket my-devops-terraform-bucket-1-20230514 \
--versioning-configuration Status=Enabled

# -----------------------------
# STEP 3: Enable Server-Side Encryption (AES256) on the S3 Bucket
# -----------------------------
aws s3api put-bucket-encryption \
--bucket my-devops-terraform-bucket-1-20230514 \
--server-side-encryption-configuration '{
"Rules": [{
"ApplyServerSideEncryptionByDefault": {
"SSEAlgorithm": "AES256"
}
}]
}'

# -----------------------------
# (Optional) Delete All Object Versions and Delete Markers from the Bucket
# -----------------------------
# - This section is useful if you're cleaning up the bucket before deletion

# Delete all object versions
aws s3api list-object-versions --bucket my-devops-terraform-bucket-1-20230514 \
--query "Versions[].{Key:Key,VersionId:VersionId}" --output text |
while read Key VersionId; do
aws s3api delete-object --bucket my-devops-terraform-bucket-1-20230514 \
--key "$Key" --version-id "$VersionId"
done

# Delete all delete markers
aws s3api list-object-versions --bucket my-devops-terraform-bucket-1-20230514 \
--query "DeleteMarkers[].{Key:Key,VersionId:VersionId}" --output text |
while read Key VersionId; do
aws s3api delete-object --bucket my-devops-terraform-bucket-1-20230514 \
--key "$Key" --version-id "$VersionId"
done

# Delete the bucket
aws s3api delete-bucket \
--bucket my-devops-terraform-bucket-1-20230514

# -----------------------------
# STEP 4: Create DynamoDB Table for Terraform State Locking
# -----------------------------
aws dynamodb create-table \
--table-name my-terraform-lock-table \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
--region eu-west-2

# -----------------------------
# Delete the DynamoDB Table (if needed)
# -----------------------------
aws dynamodb delete-table \
--table-name my-terraform-lock-table \
--region eu-west-2

# -----------------------------
# STEP 5: Initialize and Apply Terraform Configuration
# -----------------------------
terraform init     # Initializes the working directory and backend
terraform plan     # Shows the execution plan
terraform apply    # Applies the configuration and creates resources

# -----------------------------
# STEP 6: Terraform State File Access Commands
# -----------------------------
# Check if the Terraform state file exists
aws s3 ls s3://my-devops-terraform-bucket-1-20230514/terraform.tfstate

# Download the state file locally
aws s3 cp s3://my-devops-terraform-bucket-1-20230514/terraform.tfstate ./terraform.tfstate

# View the contents (pretty print JSON)
cat terraform.tfstate | jq


# -----------------------------
# 📝 Note on Remote State
# -----------------------------
Since you're using a remote state backend (S3):
The state file will be stored in your S3 bucket (my-devops-terraform-bucket-1-20230514)
Terraform configuration will be locked using DynamoDB (my-terraform-lock-table)

# -----------------------------
# 📝 🔐 Important Notes on Locking and Security
# -----------------------------
State Locking:
When you run terraform apply, DynamoDB ensures only one operation modifies the state at a time. If someone else is 
running Terraform against the same state, they will be blocked until the first operation completes
Security:
Ensure that both the S3 bucket and DynamoDB table have the correct permissions to restrict access to only authorized
users. This means setting IAM policies to control who can read, write, and modify the Terraform state and locking table