output "fallback_queue_arn" {
  value = "${aws_sqs_queue.queuefallback.arn}"
}

output "dlq_queue_arn" {
  value = "${aws_sqs_queue.queuedlq.arn}"
}
