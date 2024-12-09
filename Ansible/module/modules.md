
######################################
# Ansible adhoc-commands
######################################
- ansible do_servers -m ping
    - -m: module, ping: module name
- ansible [group] -m shell -a [command]
    - ansible do_servers -m shell -a "free -m"
    - ansible do_servers -m shell -a "uptime"
    - ansible do_servers -m shell -a "yum list installed | grep python3"
    - ansible do_servers -m shell -a "apt list --installed | grep python3"
- modules
    - number of modules ansible-doc -l | awk 'END { print NR }'
    - aws modules: ansible-doc -l | grep aws
    - number aws modules: ansible-doc -l | grep -n aws

######################################
# All modules
######################################
- https://docs.ansible.com/ansible/latest/index.html#
- Here you can learn how to use modules in your playbook