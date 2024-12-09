
#######################################################
# Ansible vault password file
#######################################################
- touch vault/ansible_vault_password
- echo "vaultpass" >  vault/ansible_vault_password
- chmod 600 vault/ansible_vault_password  (Read only)
- Add file path in ansible.cfg

#######################################################
# Encrypt data
#######################################################
- ansible-vault encrypt_string 'value' --name 'name of value' (add password)
- ansible-vault encrypt_string 'admin' --name 'db_username'
- ansible-vault encrypt_string 'adminpassword' --name 'db_password'
- vault/vault_playbook.yaml

#######################################################
# Encrypt file
#######################################################
- ansible-vault encrypt vault/secret.yaml