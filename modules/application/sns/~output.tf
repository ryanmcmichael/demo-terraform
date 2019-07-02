output "fallback_topic_arn" {
  value = "${aws_sns_topic.FallbackTopic.arn}"
}

output "topic_arn" {
  value = "${aws_sns_topic.Topic.arn}"
}

output "dlq_arn" {
  value = "${aws_sns_topic.dlq.arn}"
}

output "id_check_credits_verify_arn" {
  value = "${aws_sns_topic.id_check_credits.arn}"
}

output "id_check_credits_notify_arn" {
  value = "${aws_sns_topic.id_check_credits.arn}"
}

output "application-errors_arn" {
  value = "${aws_sns_topic.application-errors.arn}"
}

/*output "ch_form_submission_arn" {
  value = "${aws_sns_topic.ch_form_submission.arn}"
}

output "cp_send_application_arn" {
  value = "${aws_sns_topic.cp_submit_application.arn}"
}

output "ch_status_check_arn" {
  value = "${aws_sns_topic.ch-status-check.arn}"
}

output "ch_get_document_arn" {
  value = "${aws_sns_topic.ch_get_document.arn}"
}

output "ch_status_notify_arn" {
  value = "${aws_sns_topic.ch_status_notify.arn}"
}*/
