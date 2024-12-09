


# Variables
variable "region" {
  default = "europe-west2"
}

variable "machine" {
  description = "Machine details including name, type, and zone"
  type        = object({
    name         = string
    machine_type = string
    zone         = string
  })
  default = {
    name         = "ubuntu-e2-micro"
    machine_type = "e2-micro"
    zone         = "europe-west2-a"
  }
}