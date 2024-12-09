######################################
# Run virtual env
######################################
    # cd to Ansible
    # python3 -m venv venv
    # source venv/bin/activate

######################################
# Ansible installation
######################################
- Create ansible.cfg on ansible directory
- Create host file on ansible directory
- Define host on ansible.cfh, this will reference inventory that is in the hosts file

######################################
# Node configuration
######################################
- Create nodes ubuntu and centos
- Auth should be ssh only
- Add pub key to nodes (cat ~/.ssh/id_rsa.pub | pbcopy)
- Add node ip to hosts file
- ping hosts and accept connection (Host key verification)
    - ansible all -m ping