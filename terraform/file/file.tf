
# Env variables
locals {
  environment = "dev"
}
# Add provider
provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}


# Create virtual machine
resource "google_compute_instance" "e2_micro_instance" {
  name         = var.machine.name
  machine_type = var.machine.machine_type
  zone         = var.machine.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  # ssh -i ~/.ssh/my_gcp_key dopc02devops@34.89.6.113
  # ls -l ~/.ssh/my_gcp_key.pub

  metadata = {
    ssh-keys = "dopc02devops:${file("/Users/elvisngwesse/.ssh/my_gcp_key.pub")}"
  }

  tags = ["web", "ubuntu-test"]


  provisioner "local-exec" {
    command = "gcloud compute scp ./test_file.txt dopc02devops@${self.name}:~/test_file.txt --zone=${self.zone} --project=superb-gear-443409-t3"
  }


}

resource "google_project_iam_member" "gcp_user_viewer" {
  project = "superb-gear-443409-t3"
  role    = "roles/viewer"
  member  = "user:dopc02devops@gmail.com"
}

# Enable ssh
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ubuntu-test"]
}




# Variables
variable "machine" {
  description = "Machine details including name, type, and zone"
  type        = object({
    name         = string
    machine_type = string
    zone         = string
  })
  default = {
    name         = "ubuntu-e2-micro"
    machine_type = "e2-micro"
    zone         = "europe-west2-a"
  }
}


output "instance_name_ip" {
  value = {
    name = google_compute_instance.e2_micro_instance.name
    ip   = google_compute_instance.e2_micro_instance.network_interface[0].access_config[0].nat_ip
  }
  description = "The name and public IP of the VM instance"
}




#gcloud projects add-iam-policy-binding superb-gear-443409-t3 \
#--member="user:dopc02devops@gmail.com" \
#--role="roles/viewer"