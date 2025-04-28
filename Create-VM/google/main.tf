# Set environment
locals {
  environment = var.environment
}

# GCP Provider
provider "google" {
  project = var.project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# Create 2 Compute Engine instances
resource "google_compute_instance" "vm_instance" {
  count        = 2
  name         = "instance-${count.index + 1}"
  machine_type = var.machine_gcp
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network       = "default"
    access_config {} # This gives the VM a public IP
  }

  tags = ["ssh", "ping"]

  metadata = {
    ssh-keys = "gcp-user:${file(var.ssh_keys)}"
  }

  labels = {
    environment = local.environment
    role        = "ubuntu-test"
  }
}

# Firewall rule to allow SSH and Ping
resource "google_compute_firewall" "allow_ssh_and_ping" {
  name    = "allow-ssh-and-ping"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh", "ping"]
}

# Output instance names and public IPs
output "instance_names_ips" {
  value = [
    for vm in google_compute_instance.vm_instance : {
      name = vm.name
      ip   = vm.network_interface[0].access_config[0].nat_ip
    }
  ]
  description = "The names and public IPs of the GCP instances"
}
