

# Variables
variable "apache_variable" {
  description = "Machine details including name, type, and zone"
  type        = object({
    name         = string
    machine_type = string
    zone         = string
  })
  default = {
    name         = "apache-web-server"
    machine_type = "e2-micro"
    zone         = "europe-west2-a"
  }
}