######################################
# Inventory
######################################
- Get inventory plugins
    - ansible-doc -t inventory -l
- Get dynamic inventory digital ocean
    - ansible-galaxy collection install community.digitalocean
    - create digital ocean token
      - export DO_API_TOKEN="your-token-here"
      - create file digitalocean_credentials.yaml
      - create file digitalocean_inventory.yaml
      - execute command: ansible-inventory -i inventory/digitalocean_inventory.yaml --graph -vvvv
        - -vvvv is used to debug ansible command (The issue is file name mismatch)
      - rename file to digitalocean.yml
      - execute command: ansible-inventory -i inventory/digitalocean.yaml --graph
      - execute command: ansible-inventory -i inventory/digitalocean.yaml --graph --vars
      - ping command: ansible all -i inventory/digitalocean.yaml -m ping