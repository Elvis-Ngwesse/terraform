######################################
# Playbooks
######################################
# Structure
- Playbook Header (Optional)
    - # Playbook to configure a web server with NGINX and deploy application code
      # Author: Your Name
      # Date: YYYY-MM-DD
- Play
    - Ansible playbooks consist of plays, which target specific hosts and define what tasks to run on them. Each play 
      typically includes:
        - name: Configure web servers (Describes what the play does)
          hosts: web_servers (Specifies the target hosts)
          become: yes (Indicates whether privilege escalation is required)
          become_user:root
          vars_files: (Optional section for variables)
            - vars/common.yml
- Tasks 
    - Each play contains a list of tasks that define the actions to perform on the target hosts
      tasks:
       - name: Install NGINX (Provides a short description of the task)
         apt: (Each task uses an Ansible module (e.g., apt, yum, service))
           name: nginx
           state: present
         when: ansible_os_family == "Debian" ( (Optional) Conditions to decide when a task should run, using when)

       - name: Copy application files
         copy:
           src: /local/path/to/app/
           dest: /var/www/html/

- Handlers
    - Handlers are tasks that are only executed when triggered by other tasks, typically for actions like restarting services
      handlers:
       - name: restart nginx
         service:
           name: nginx
           state: restarted
- Variables
    - Variables can be defined at different levels: in playbooks, external files, or within the inventory
      vars:
        app_directory: /var/www/html
        nginx_port: 80
- Roles
    - Roles help organize tasks, handlers, templates, and files into reusable units
      roles:
        - nginx
        - app_deployment
- Environment Variables
    - Environment can define environment variables for tasks or plays, often used to set paths or configurations
      environment:
        PATH: "{{ ansible_env.PATH }}:/custom/path"
- Tags
    - Tags allow you to run specific tasks or plays selectively, which is useful for testing or debugging
      tasks:
      - name: Install dependencies
        apt:
          name: "{{ item }}"
          state: present
        loop:
          - nginx
          - curl
        tags:
          - dependencies

  - Including Other Playbooks or Task Files
      - include_tasks and import_tasks allow you to break down complex playbooks into reusable components.
      - include_playbook can call additional playbooks within the main playbook
        - include_tasks: setup.yml
        - import_tasks: deploy.yml

######################################
# run playbook
######################################
- Run playbook
    - ansible-playbook -i inventory/digitalocean.yaml playbooks/apache_nginx_install_playbook.yaml.yaml
- Run playbook as executable
    - Add #! plus file path to beginning of script
    - Add inventory file path to ansible.cfg file
    - Make playbook.yaml file executable
    - Add shebang to playbook.yaml
        - #!/usr/bin/env -S ansible-playbook -K
    - Run file using file name (playbooks/apache_nginx_install_playbook.yaml.yaml)
- Dry run  
    - Nothing will be installed on the node, just the output will be displayed
    - playbooks/install_playbook.yaml --check
- Verbose output
    - This mode will display logs. The more vvvvvvv, the more logs are displayed
    - playbooks/apache_nginx_install_playbook.yaml.yaml -v
    - If verbosity=2 is set in the playbook, u must run the file with -vv to display the logs
