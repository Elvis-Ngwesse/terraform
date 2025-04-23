

output "apache_ip" {
  value = {
    name = google_compute_instance.web_server_apache.name
    ip   = google_compute_instance.web_server_apache.network_interface[0].access_config[0].nat_ip
  }
  description = "The name and public IP of the web_server_apache"
}