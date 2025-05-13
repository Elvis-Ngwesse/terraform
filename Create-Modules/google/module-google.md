# Show current workspace
echo "---------------------------"
terraform workspace show
echo "---------------------------"

# Create a new workspace named 'dev'
echo "---------------------------"
terraform workspace new dev
echo "---------------------------"

# Select the 'dev' workspace
echo "---------------------------"
terraform workspace select dev
echo "---------------------------"

# List all workspaces
echo "---------------------------"
terraform workspace list
echo "---------------------------"


💻 Copy the External IP of your GCP instance:

-----------------------------
After your GCP instance is created, go to the Google Cloud Console.
Navigate to the VM instances section.
Find your instance and locate the External IP address (it will be listed under the Network interfaces section).
Copy the external IP (it will look like xx.xx.xx.xx).

-----------------------------
🌐 Open and Paste in Your Web Browser:

-----------------------------
Once you have the external IP, open a web browser.
Paste the copied IP into the browser’s address bar, like this:
http://xx.xx.xx.xx

-----------------------------
