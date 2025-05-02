
# SSH into Instance
- gcloud compute ssh gcp-user@instance-1 --zone=europe-west2-a
- ssh -i ~/.ssh/gcp_key gcp-user@public_ip

# SSH ProxyJump (Direct from Local Machine)
- vim ~/.ssh/config
- Update file with ip of private and public instances
  - Host bastion
    HostName 34.89.66.252
    User gcp-user
    IdentityFile ~/.ssh/gcp_key 
  - Host private 
    HostName 10.0.2.2
    User gcp-user
    IdentityFile ~/.ssh/gcp_key
    ProxyJump bastion
- SSH into private instance
  - ssh private
  - sudo apt update && sudo apt upgrade -y

