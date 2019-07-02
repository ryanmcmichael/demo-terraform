variable "bastion_elb_port" {
  type = "string"
}

variable "bastion_elb_security_group_id" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "project" {
  type = "string"
}

variable "log_bucket_id" {
  type = "string"
}

variable "public_subnet_ids" {
  type = "string"
}