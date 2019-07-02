variable "allow_ssh" {
  type = "string"
  default = "deny"
}

variable "bastion_elb_port" {
  type = "string"
  default = "22"
}

variable "bastion_whitelist_cidr_blocks" {
  type = "string"
}

variable "whitelist_cidr_blocks" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "vpc_cidr_block" {
  type = "string"
}

variable "vpc_default_network_acl_id" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "zone_count" {
  type = "string"
}

variable "zones" {
  type = "string"
}