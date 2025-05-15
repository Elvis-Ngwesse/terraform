# --------------------------------------------------------------
# 1. Create a Python virtual environment
# --------------------------------------------------------------
python3 -m venv venv  # Create a virtual environment named 'venv'
source venv/bin/activate  # Activate the virtual environment

# --------------------------------------------------------------
# 2. Email configuration (Example email, can be replaced)
# --------------------------------------------------------------
# Email: aws.gcp.devops.elvis@gmail.com

# --------------------------------------------------------------
# 3. Terraform Installation
# --------------------------------------------------------------
brew tap hashicorp/tap  # Tap HashiCorp's official Homebrew repository
brew install hashicorp/tap/terraform  # Install Terraform via Homebrew
terraform -v  # Verify the Terraform installation

# --------------------------------------------------------------
# 4. Create an SSH Public Key (for secure communication with cloud providers)
# --------------------------------------------------------------
ssh-keygen -t rsa -b 4096 -f ~/.ssh/[key-name]  # Generate SSH key pair with a custom name

# --------------------------------------------------------------
# 5. Google Cloud CLI Login
# --------------------------------------------------------------
gcloud auth login  # Authenticate using your Google account for Google Cloud CLI

# --------------------------------------------------------------
# 6. Terraform Workspaces
# --------------------------------------------------------------
terraform workspace list  # List all available workspaces
terraform workspace new dev  # Create a new workspace named 'dev'
terraform workspace show  # Show the current active workspace
terraform workspace select test  # Switch to the 'test' workspace (replace 'test' with your desired workspace)

# --------------------------------------------------------------
# 7. GCP Credentials File Path
# --------------------------------------------------------------
# Define the path to your GCP credentials file (ensure the path is correct)
gcp_key_path="/Users/elvisngwesse/Desktop/Repositories/terraform/gcp-key.json"
