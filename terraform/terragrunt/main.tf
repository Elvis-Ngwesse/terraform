provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = var.tags
}


output "vm_instance_name" {
  value = google_compute_instance.vm_instance.name
}

output "vm_instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

#terragrunt init
#terragrunt plan
#terragrunt apply
#terragrunt output
#terragrunt destroy
#terragrunt destroy --terragrunt-log-level=debug

