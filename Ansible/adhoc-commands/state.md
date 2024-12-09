
######################################
# State
######################################
- Add/remove/update module
    - ansible do_servers -m yum/apt -a "name=nginx state=present" -b 
    - The above -b appends sudo to the command
    - state=removed
    - state=latest
    - state=absent
- Get information about nodes using setup module (Python interpreter at /usr/bin/python3.9)
  - ansible do_servers -m setup
  - ansible do_servers -m setup -a "filter=ansible_memory"