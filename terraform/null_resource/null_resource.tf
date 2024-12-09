resource "null_resource" "gcp_setup" {
  provisioner "local-exec" {
    command = <<EOT
    echo "Running GCP setup script..."
    gcloud compute instances list --project superb-gear-443409-t3
    echo "GCP setup completed!"
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}
