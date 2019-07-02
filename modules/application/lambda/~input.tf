#------------LAMBDA VARIABLES------------

variable "lambda_functions_bucket" {
  type = "string"
}

variable "placeholder_package" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "account" {
  type = "string"
}

variable "aws_account_id" {
  type = "string"
}

variable "lambda_common_role_arn" {
  type = "string"
}

variable "services_subnet_ids" {
  type = "list"
}

variable "lambda_security_group_id" {
  type = "string"
}

variable "kms_key_arn" {
  type = "string"
}