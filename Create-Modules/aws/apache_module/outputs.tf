# -----------------------------
# outputs.tf
# -----------------------------

output "web_server_ip" {
  description = "The public IP address of the Apache web server instance."
  value       = aws_instance.web_server_apache.public_ip
}

output "web_server_id" {
  description = "The ID of the Apache EC2 instance."
  value       = aws_instance.web_server_apache.id
}

