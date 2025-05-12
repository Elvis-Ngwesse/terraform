# -------------------------------
# Output the NGINX Server Information
# -------------------------------
output "nginx_server_name" {
  description = "The name of the NGINX server"
  value       = google_compute_instance.web_server_nginx.name
}

output "nginx_machine_type" {
  description = "The machine type of the NGINX server"
  value       = google_compute_instance.web_server_nginx.machine_type
}

output "nginx_zone" {
  description = "The zone of the NGINX server"
  value       = google_compute_instance.web_server_nginx.zone
}

output "nginx_external_ip" {
  description = "The external IP address of the NGINX server"
  value       = google_compute_instance.web_server_nginx.network_interface[0].access_config[0].nat_ip
}

# -------------------------------
# Output the Firewall Rule Details
# -------------------------------
output "firewall_rule_name" {
  description = "The name of the firewall rule"
  value       = google_compute_firewall.allow_https.name
}

output "firewall_ports" {
  description = "The allowed ports in the firewall rule"
  value       = [for rule in google_compute_firewall.allow_https.allow : rule.ports][0]
}

output "firewall_source_ranges" {
  description = "The allowed source ranges for the firewall"
  value       = google_compute_firewall.allow_https.source_ranges
}
