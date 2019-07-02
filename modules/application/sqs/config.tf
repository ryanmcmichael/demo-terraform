resource "aws_sqs_queue" "queuedlq" {
  name                      = "${var.environment}-queuedlq"
  delay_seconds             = 300
  max_message_size          = 262144
  message_retention_seconds = 604800
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 7200
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.queuefallback.arn}\",\"maxReceiveCount\":6}"
}

resource "aws_sqs_queue_policy" "queuedlq" {
  queue_url = "${aws_sqs_queue.queuedlq.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:${var.region}:${var.aws_account_id}:*"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "queuefallback" {
  name                      = "${var.environment}-queuefallback"
  delay_seconds             = 900
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 20
  visibility_timeout_seconds = 3600
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.queuefallbackdlq.arn}\",\"maxReceiveCount\":6}"
}

resource "aws_sqs_queue_policy" "queuefallback" {
  queue_url = "${aws_sqs_queue.queuefallback.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.cp_submit_application_lambda_arn}"
        }
      }
    },
    {
      "Sid": "Second",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.ch_form_submission_lambda_arn}"
        }
      }
    }
  ]
}
POLICY
}


resource "aws_sqs_queue" "queuefallbackdlq" {
  name                      = "${var.environment}-queuefallbackdlq"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30
}

resource "aws_sqs_queue_policy" "queuefallbackdlq" {
  queue_url = "${aws_sqs_queue.queuefallbackdlq.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "*",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:${var.region}:${var.aws_account_id}:*"
        }
      }
    }
  ]
}
POLICY
}