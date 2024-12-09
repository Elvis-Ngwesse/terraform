
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


# Create network or vpc for vm
resource "google_compute_network" "vpc" {
  name = "${local.environment}-vpc-for-ubuntu"
  auto_create_subnetworks = "false"
  routing_mode = "GLOBAL"
}


# create the public subnet
resource "google_compute_subnetwork" "public_subnet" {
  name = "${local.environment}-public-subnet-1"
  ip_cidr_range = "10.10.1.0/24"
  network = google_compute_network.vpc.name
  region = var.region
}


# Enable port 90 to allow http traffic
resource "google_compute_firewall" "allow-http" {
  name = "${local.environment}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}


# Enable port 443 to allow https traffic
resource "google_compute_firewall" "allow-https" {
  name = "${local.environment}-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https"]
}


# Enable port 22 to allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name = "${local.environment}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}


# Enable port 3389 to allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name = "${local.environment}-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["rdp"]
}

# Static ip
resource "google_compute_address" "static_ip" {
  name   = "${local.environment}-my-static-ip"
  region = "europe-west2"
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
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  tags = ["web", "ubuntu-test"]
}


output "instance_name_ip" {
  value = {
    name = google_compute_instance.e2_micro_instance.name
    ip   = google_compute_instance.e2_micro_instance.network_interface[0].access_config[0].nat_ip
  }
  description = "The name and public IP of the VM instance"
}
