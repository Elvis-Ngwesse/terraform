# -----------------------------
# Server Name for Production and Development Environments
# -----------------------------

variable "nginx_prod_server_name" {
  description = "The name of the NGINX server in the production environment. This will be used for identifying the instance in the cloud platform and for configuration purposes."
  type        = string
  default     = "nginx-prod-server"
}

variable "nginx_dev_server_name" {
  description = "The name of the NGINX server in the development environment. This is used to distinguish between the production and development servers."
  type        = string
  default     = "nginx-dev-server"
}

# -----------------------------
# Machine Types for Production and Development Environments
# -----------------------------

variable "nginx_prod_machine_type" {
  description = "The machine type for the NGINX server in the production environment. This determines the CPU, memory, and overall capacity of the instance."
  type        = string
  default     = "n1-standard-2"
}

variable "nginx_dev_machine_type" {
  description = "The machine type for the NGINX server in the development environment. This is typically a smaller machine compared to production to save costs."
  type        = string
  default     = "e2-micro"
}

# -----------------------------
# Zones for Production and Development Environments
# -----------------------------

variable "nginx_prod_zone" {
  description = "The GCP zone where the NGINX server will be located in the production environment. Zones define the geographical region for your resources."
  type        = string
  default     = "us-central1-a"
}

variable "nginx_dev_zone" {
  description = "The GCP zone where the NGINX server will be located in the development environment. Typically, this might differ from production to ensure geographical diversity or cost optimization."
  type        = string
  default     = "europe-west2-a"
}

# -----------------------------
# Image used for the instance
# -----------------------------

variable "nginx_image" {
  description = "The image to use for initializing the NGINX server instance. This is an Ubuntu 20.04 LTS image, which is a stable release suitable for running NGINX."
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
}

# -----------------------------
# Network settings
# -----------------------------

variable "nginx_network" {
  description = "The network to attach the NGINX instance to. In this case, it is the default network, but you can create custom networks for better isolation."
  type        = string
  default     = "default"
}

# -----------------------------
# Tags to apply to the NGINX instance and firewall
# -----------------------------

variable "nginx_tags" {
  description = "The tags applied to the NGINX instance and firewall rules to identify and filter traffic. For example, 'web' can be used to allow HTTP/HTTPS traffic."
  type        = list(string)
  default     = ["web"]
}

# -----------------------------
# HTTPS Ports
# -----------------------------

variable "nginx_https_ports" {
  description = "A list of ports to allow for HTTPS traffic. The default is port 443, which is the standard port for secure web traffic."
  type        = list(string)
  default     = ["80"]
}

# -----------------------------
# Source IP ranges for firewall rules
# -----------------------------

variable "nginx_source_ranges" {
  description = "The source IP ranges allowed for incoming traffic to the NGINX instance. The default allows all incoming traffic from any IP address (0.0.0.0/0)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}