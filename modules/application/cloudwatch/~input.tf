variable "fallback_topic_arn" {
  type = "string"
}

variable "topic_arn" {
  type = "string"
}

variable "bastion_autoscaling_group_name" {
  type = "string"
}

variable "application-errors_arn" {
  type = "string"
}

variable "demo_api_name" {
  type = "string"
}

variable "fallback_dlq_name" {
  type = "string"
}

variable "prod_demo_db_name" {
  type = "string"
}

variable "ch_form_submission_lambda_name" {
  type = "string"
}

variable "user_login_lambda_name" {
  type = "string"
}

variable "user_register_lambda_name" {
  type = "string"
}