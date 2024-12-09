
######################################
# Server grouping
######################################
- To group server execution, create server groups in the host file
    - [do_servers]
    - ansible do_servers -m ping

######################################
# networking
######################################
- Add public key to ubuntu
  - ssh-copy-id ansible_user@161.35.43.240