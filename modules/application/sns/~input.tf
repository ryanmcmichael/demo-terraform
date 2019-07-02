variable "environment" {
  type = "string"
}

variable "aws_account_id" {
  type = "string"
}

variable "fallback_queue_arn" {
  type = "string"
}

variable "dlq_queue_arn" {
  type = "string"
}

variable "ch_get_document_lambda_arn" {
  type = "string"
}

variable "ch_status_notify_lambda_arn" {
  type = "string"
}

variable "cp_submit_application_lambda_arn" {
  type = "string"
}

variable "id_check_credits_verify_queue_arn" {
  type = "string"
}

variable "ch-status-check_lambda_arn" {
  type = "string"
}

variable "ch_form_submission_lambda_arn" {
  type = "string"
}