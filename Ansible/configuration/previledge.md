
######################################
# Edit files
######################################
- Edit config file
    - vim  /etc/ssh/sshd_config
- Give user sudo previledge
    - sudo visudo (Redhat)
    - sudo EDITOR=vim visudo (Debian)
    - your_user ALL=(ALL) NOPASSWD: ALL  (Add in file)