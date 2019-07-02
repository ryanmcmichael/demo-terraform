variable "bastion_image_id" {
  type = "string"
}

variable "bastion_elb_name" {
  type = "string"
}

variable "config_bucket" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "ini_kms_key_arn" {
  type = "string"
}

variable "instance_key_name" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "mgt_subnet_ids" {
  type = "string"
}

variable "pub_subnet_ids" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "security_group_ids" {
  type = "string"
}
