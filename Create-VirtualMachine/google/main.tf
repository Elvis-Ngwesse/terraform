# -----------------------------
# Set environment as a local variable
# -----------------------------
locals {
  environment = var.environment
}

# -----------------------------
# Configure GCP Provider
# -----------------------------
provider "google" {
  credentials = file(var.gcp_credentials_file)  # Path to GCP service account credentials JSON file
  project     = var.project_id                  # GCP project ID
  region      = var.gcp_region                  # Default region for resources
  zone        = var.gcp_zone                    # Default zone for zonal resources
}

# -----------------------------
# Create a custom VPC network
# -----------------------------
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"     # Name of the VPC
  auto_create_subnetworks = false                # Disable automatic subnet creation
}

# -----------------------------
# Create a public subnet
# -----------------------------
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"                    # Public subnet name
  ip_cidr_range = "10.0.1.0/24"                  # IP range for the public subnet
  network       = google_compute_network.vpc_network.id
  region        = var.gcp_region
}

# -----------------------------
# Create a private subnet
# -----------------------------
resource "google_compute_subnetwork" "private_subnet" {
  name                     = "private-subnet"     # Private subnet name
  ip_cidr_range            = "10.0.2.0/24"         # IP range for the private subnet
  network                  = google_compute_network.vpc_network.id
  region                   = var.gcp_region
  private_ip_google_access = true                 # Allow access to Google APIs without public IP
}

# -----------------------------
# Create a Cloud Router (required for Cloud NAT)
# -----------------------------
resource "google_compute_router" "router" {
  name    = "quickstart-router"
  network = google_compute_network.vpc_network.id
  region  = var.gcp_region
}

# -----------------------------
# Create a Cloud NAT to allow outbound internet access for private instances
# -----------------------------
resource "google_compute_router_nat" "nat" {
  name                               = "quickstart-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# -----------------------------
# Create a firewall rule to allow SSH (TCP 22) and ICMP (ping)
# -----------------------------
resource "google_compute_firewall" "allow_ssh_and_ping" {
  name    = "allow-ssh-and-ping"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80-90", "8080-8090", "3306"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh", "ping"]
}

# -----------------------------
# Create one Compute Engine VM instances in the public subnet
# -----------------------------
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

    access_config {}  # Public IP address assigned
  }

  tags = ["dev", count.index == 0 ? "master" : "worker"]

  metadata = {
    ssh-keys = "gcp-user:${file("/Users/elvisngwesse/.ssh/gcp_key.pub")}"
  }

  labels = {
    environment = local.environment
    role        = "ubuntu-test"
    ansible-managed = "true"
  }

  depends_on = [
    google_compute_firewall.allow_ssh_and_ping
  ]
}

# -----------------------------
# Create one Compute Engine VM instance in the private subnet (no public IP)
# -----------------------------
resource "google_compute_instance" "private_vm" {
  name         = "private-instance"
  machine_type = var.machine_gcp
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.private_subnet.id
    # No access_config => No public IP
  }

  tags = ["ssh", "ping"]

  metadata = {
    ssh-keys = "gcp-user:${file("/Users/elvisngwesse/.ssh/gcp_key.pub")}"
  }

  labels = {
    environment = local.environment
    role        = "private-ubuntu"
  }

  depends_on = [
    google_compute_firewall.allow_ssh_and_ping,
    google_compute_router_nat.nat
  ]
}

# -----------------------------
# Output public instances' names and public IPs
# -----------------------------
output "instance_names_ips" {
  value = [
    for vm in google_compute_instance.vm_instance : {
      name = vm.name
      ip   = vm.network_interface[0].access_config[0].nat_ip
    }
  ]
  description = "The names and public IPs of the GCP instances in the public subnet"
}

# -----------------------------
# Output private instance internal IP
# -----------------------------
output "private_instance_internal_ip" {
  value       = google_compute_instance.private_vm.network_interface[0].network_ip
  description = "The internal IP of the private VM instance"
}
