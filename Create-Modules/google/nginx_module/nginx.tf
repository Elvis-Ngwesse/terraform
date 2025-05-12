locals {
  nginx_server_name  = terraform.workspace == "prod" ? var.nginx_prod_server_name : var.nginx_dev_server_name
  nginx_machine_type = terraform.workspace == "prod" ? var.nginx_prod_machine_type : var.nginx_dev_machine_type
  nginx_zone         = terraform.workspace == "prod" ? var.nginx_prod_zone : var.nginx_dev_zone
}

# -------------------------------
# Google Compute Instance (NGINX Server)
# -------------------------------
resource "google_compute_instance" "web_server_nginx" {
  name         = local.nginx_server_name
  machine_type = local.nginx_machine_type
  zone         = local.nginx_zone

  boot_disk {
    initialize_params {
      image = var.nginx_image
    }
  }

  network_interface {
    network = var.nginx_network
    access_config {} # Assigns an external IP to the instance
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx

    # Make sure nginx listens on port 80 (default)
    sed -i 's/listen 127.0.0.1:80;/listen 0.0.0.0:80;/' /etc/nginx/sites-available/default

    # Restart nginx to apply changes
    systemctl restart nginx
  EOT

  tags = var.nginx_tags
}

# -------------------------------
# Google Compute Firewall (Allow HTTPS)
# -------------------------------
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = var.nginx_network

  allow {
    protocol = "tcp"
    ports    = var.nginx_https_ports
  }

  source_ranges = var.nginx_source_ranges
  target_tags   = var.nginx_tags
}