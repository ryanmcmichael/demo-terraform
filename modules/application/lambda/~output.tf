output "ch-status-check_lambda_arn" {
  value = "${aws_lambda_function.ch-status-api.arn}"
}

output "ch_form_submission_lambda_arn" {
  value = "${aws_lambda_function.ch-form-submission-api.arn}"
}

output "ch_get_document_lambda_arn" {
  value = "${aws_lambda_function.ch-get-document-api.arn}"
}

output "ch_status_notify_lambda_arn" {
  value = "${aws_lambda_function.send-status-notification.arn}"
}

output "cp_submit_application_lambda_arn" {
  value = "${aws_lambda_function.cashplus-submit-application.arn}"
}

output "id_check_credits_verify_queue_arn" {
  value = "${aws_lambda_function.id-check-credits.arn}"
}

output "user_login_lambda_name" {
  value = "${aws_lambda_function.user-login.function_name}"
}

output "user_register_lambda_name" {
  value = "${aws_lambda_function.user-register-v2.function_name}"
}
