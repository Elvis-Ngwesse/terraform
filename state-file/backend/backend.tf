


# Add provider
provider "google" {
  project = "superb-gear-443409-t3"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

terraform {
  backend "gcs" {
    bucket         = "tf-e2ihp3odiue36xl3"
    prefix         = "terraform/state"
  }
}