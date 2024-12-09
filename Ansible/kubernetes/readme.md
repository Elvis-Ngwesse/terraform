
#######################################################
# Create kube_user
#######################################################
- Add digitalocean.yaml or hosts
- Add ansible.cfg file
- Make sure ansible_user=root in digitalocean.yaml file
- Run create_users_playbook.yaml play
- ./create_users_playbook.yaml

#######################################################
# Install Docker and its dependent components
#######################################################
- ./kubernetes_plabook.yaml
- 
#######################################################
# Initialize your Master node with Kubernetes
#######################################################
- ./add_master_playbook.yaml

#######################################################
# Connect your worker nodes to the master node
#######################################################
- ./add_worker_playbook.yaml

#######################################################
# Login to the master node as kube_user
#######################################################
- kubectl get nodes
- kubectl get all -A

#######################################################
#######################################################
# Install NFS server
#######################################################
- mkdir kubernetes
- cd kubernetes
- Make sure nfs server is running
    - showmount -e [master node ip]
    - Add user if it does not exist
        - ./users_playbook.yaml
    - if not install playbook 
        - ./nfs_server_playbook.yaml
    - Apply nfs provisioner on master node
        - ./nfs_provider_playbook.yaml
    - Create pvc
        - ./pvc_playbook.yml
    - Check if exist on file system
        - ls -l /k8mount
        - df -h /k8mount
        - cd /k8mount
    - Check pv and pvc created
        - kubectl get pvc -n dev
          kubectl get pv -n dev
        - kubectl get pods --all-namespaces
    - Deploy sample nginx app
        - ./deploy_nginx_playbook.yml

#######################################################
# Kubernetes Dashboard
#######################################################
- Run file
    - ./dashboard_playbook.yaml
- Run command on shell (localhost)
    - ssh -L 8001:127.0.0.1:8001 kube_user@master_ip
      kubectl proxy
- Navigate to the dashboard page from a web browser on your local machine
    - http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
    - 
#######################################################
# Uninstall NFS-Server
#######################################################
- Remove nfs-server
    - sudo systemctl stop nfs-kernel-server
      sudo systemctl disable nfs-kernel-server
      sudo apt remove --purge -y nfs-kernel-server
      sudo rm -rf /etc/exports
      sudo rm -rf /var/lib/nfs
      sudo apt autoremove -y
      sudo apt autoclean
- Remove folder
    - sudo rm -rf /k8mount/*
    - sudo rm -rf /k8mount

#######################################################
# Copy files to master
#######################################################
- Either run the below file or copy individual files
    - ./copy_helm_charts_playbook.yaml
- Individual adhoc commands
    - ansible all -m copy -a "src=../../Helm dest=/home/kube_user mode=0755" -b
      ansible master -m copy -a "src=../../Helm/dynamodbchart dest=/home/kube_user/Helm mode=0755" -b
      ansible master -m copy -a "src=../../Helm/chartpostgress dest=/home/kube_user/Helm mode=0755" -b
      ansible master -m copy -a "src=../../Helm/bookchart dest=/home/kube_user/Helm mode=0755" -b
      ansible master -m copy -a "src=../../Helm/employeechart dest=/home/kube_user/Helm mode=0755" -b
      ansible master -m copy -a "src=../../Helm/chartnginx dest=/home/kube_user/Helm mode=0755" -b
      ansible master -m copy -a "src=../../Helm/helmfile.yaml dest=/home/kube_user/Helm mode=0755" -b

#######################################################
# Delete kubernetes and dependencies
#######################################################
sudo systemctl stop kubelet
sudo systemctl disable kubelet
sudo apt-get remove -y kubeadm kubelet kubectl
sudo apt-get autoremove -y
sudo apt-get purge -y kubeadm kubelet kubectl
sudo apt-get remove -y kubernetes-cni kubernetes-client kubernetes-server
sudo apt-get autoremove -y
sudo apt-get remove -y docker.io containerd.io
sudo apt-get purge -y docker.io containerd.io
sudo apt-get autoremove -y
sudo rm -rf /etc/kubernetes
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.asc
sudo rm -f /etc/default/kubelet
sudo rm -rf /etc/systemd/system/kubelet.service.d
sudo userdel kubelet
sudo groupdel kubelet
sudo iptables -F
sudo apt-get autoclean
sudo apt-get autoremove -y
sudo reboot




sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 234654DA9A296436
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /etc/apt/trusted.gpg.d/kubernetes.asc



sudo rm /etc/apt/sources.list.d/kubernetes.list
sudo apt-get clean
sudo apt-get update


curl -4 -s https://dl.k8s.io/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list



echo “deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /” | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg