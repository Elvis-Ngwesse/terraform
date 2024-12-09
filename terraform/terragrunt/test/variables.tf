variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "instance_name" {}
variable "machine_type" {}
variable "image" {}
variable "tags" {
  description = "A map of tags to apply to resources"
  type        = set(string)
  default     = ["test", "web"]

}
