## AWS
# Create ssh-key #
- Create key from cli:
    aws ec2 create-key-pair --key-name my-ssh-key --query "KeyMaterial" --output text > my-ssh-key.pem

# IAM Policies AWS
- Give User readonly access policy:
    aws iam attach-user-policy --user-name aws-elvis --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# Login to VM's
chmod 400 my-ssh-key.pem
ssh -i my-ssh-key.pem ec2-user@<public-ip>