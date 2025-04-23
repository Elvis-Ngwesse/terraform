
# Add provider
provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

module "apache" {
  source = "./apache_module"
}

module "nginx" {
  source = "./nginx_module"
}