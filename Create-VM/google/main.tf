# Set environment
locals {
  environment = var.environment
}

# GCP Provider
provider "google" {
  credentials = file(var.gcp_credentials_file)
  project = var.project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.id
  region        = var.gcp_region
}

resource "google_compute_router" "router" {
  name    = "quickstart-router"
  network = google_compute_network.vpc_network.id
  region  = var.gcp_region
}

resource "google_compute_router_nat" "nat" {
  name                               = "quickstart-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Firewall rule to allow SSH and Ping
resource "google_compute_firewall" "allow_ssh_and_ping" {
  name    = "allow-ssh-and-ping"
  network = google_compute_network.vpc_network.name

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
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {} # Assigns a public IP
  }

  tags = ["ssh", "ping"]

  metadata = {
    ssh-keys = "gcp-user:${var.ssh_key_file}"
  }

  labels = {
    environment = local.environment
    role        = "ubuntu-test"
  }

  depends_on = [
    google_compute_firewall.allow_ssh_and_ping
  ]
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
