
locals {
  apache_server_name = terraform.workspace == "prod" ? "nginx-prod-server" : "nginx-dev-server"
  apache_machine_type = terraform.workspace == "prod" ? "n1-standard-2" : "e2-micro"
  apache_zone = terraform.workspace == "prod" ? "us-central1-a" : "europe-west2-a"
}


# Create the VM instance
resource "google_compute_instance" "web_server_nginx" {
  name         = var.nginx_variable.name
  machine_type = var.nginx_variable.machine_type
  zone         = var.nginx_variable.zone

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

    # Install NGINX
    sudo apt-get install -y nginx

    # Start NGINX service
    sudo systemctl start nginx

    # Enable NGINX to start on boot
    sudo systemctl enable nginx
  EOT

  tags = ["web"]
}

# Create a firewall rule to allow HTTPs traffic
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}