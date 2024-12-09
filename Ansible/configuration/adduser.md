
######################################
# Add user (Always good to add user)
######################################
- sudo adduser ansible_user
- id ansible_user (Verify user added)
- su - ansible_user
- mkdir ~/.ssh
  chown -R ansible_user:ansible_user /home/ansible_user/.ssh
  chmod 0700 /home/ansible_user/.ssh
  vim ~/.ssh/authorized_keys
  chmod 0600 /home/ansible_user/.ssh/authorized_keys
  cat ~/.ssh/id_rsa.pub | pbcopy (Copy and paste public key)






