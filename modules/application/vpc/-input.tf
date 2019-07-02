variable "environment" {
  type = "string"
}

variable "environment_cidr_block" {
  type = "string"
}

variable "instance_tenancy" {
  type = "string"
  default = "default"
}