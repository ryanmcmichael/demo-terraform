variable "image_id" {
  type = "string"
}

variable "config_bucket" {
  type = "string"
}

variable "ebs_optimized_instances" {
  type = "string"
  default = "false"
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

variable "name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "role_policy" {
  type = "string"
}

variable "security_group_ids" {
  type = "string"
}

variable "user_data" {
  type = "string"
}

variable "associate_public_ip_address" {
  type = "string"
}