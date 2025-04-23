
locals {
  apache_server_name = terraform.workspace == "prod" ? "apache-prod-server" : "apache-dev-server"
  apache_machine_type = terraform.workspace == "prod" ? "n1-standard-2" : "e2-micro"
  apache_zone = terraform.workspace == "prod" ? "us-central1-a" : "europe-west2-a"
}


# Create the VM instance
resource "google_compute_instance" "web_server_apache" {
  name         = var.apache_variable.name
  machine_type = var.apache_variable.machine_type
  zone         = var.apache_variable.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Assigns an external IP to the instance
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Update the package list
    sudo apt-get update

    # Install Apache
    sudo apt-get install -y apache2

    # Start Apache service
    sudo systemctl start apache2

    # Enable Apache to start on boot
    sudo systemctl enable apache2
  EOT

  tags = ["web"]
}

# Create a firewall rule to allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}