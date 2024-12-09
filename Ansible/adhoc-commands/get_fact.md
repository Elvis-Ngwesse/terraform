

######################################
# Fact
######################################
# The /etc/ansible/facts.d/ directory is used by Ansible to store custom facts that can be used within playbooks or 
# other Ansible modules. These custom facts are typically stored in files with a .fact extension. The files inside 
# this directory can contain facts in either JSON or INI format.

- Get facts
  - create get_version.fact
  - Create facts.d directory on nodes
    - ansible do_servers -m file -a "path=/etc/ansible/facts.d state=directory" -b (You get Permission denied without -b)
  - Move get_version.fact to nodes
    - ansible do_servers -m copy -a "src=./get_version.fact dest=etc/ansible/facts.d" -b
    - file is not executable with "mode": "0664"
    - ansible do_servers -m copy -a "src=adhoc-commands/get_version.fact dest=/etc/ansible/facts.d mode=0755" -b
    - ansible do_servers -m setup -a "filter=ansible_local"
- Delete directory/file
  - ansible do_servers -m file -a "path=/etc/ansible/facts.d state=absent"
  - ansible do_servers -m file -a "path=/etc/ansible/facts.d/get_version.fact state=absent" -b
- Verify state
  - ansible do_servers -m stat -a "path=/etc/ansible/facts.d"
  - ansible do_servers -m stat -a "path=/etc/ansible/facts.d/get_version.fact"