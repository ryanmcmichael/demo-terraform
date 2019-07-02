resource "aws_sns_topic" "Topic" {
  name = "Topic"
}

resource "aws_sns_topic_policy" "Topic-TopicPolicy" {
  arn = "${aws_sns_topic.Topic.arn}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigSNSPolicy20180202",
      "Action": [
        "SNS:Publish",
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.Topic.arn}",
      "Principal": {
        "AWS": "*"
      },
      "Condition":{
         "StringEquals":{
            "AWS:SourceAccount":"${var.aws_account_id}"
          }
      }
    }
  ]
}
EOF
}


resource "aws_sns_topic" "FallbackTopic" {
  name = "FallbackTopic"
}

resource "aws_sns_topic_policy" "FallbackTopic-TopicPolicy" {
  arn = "${aws_sns_topic.FallbackTopic.arn}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigSNSPolicy20180201",
      "Action": [
        "SNS:Publish",
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.FallbackTopic.arn}",
      "Principal": {
        "AWS": "*"
      },
      "Condition":{
         "StringEquals":{
            "AWS:SourceAccount":"${var.aws_account_id}"
          }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic" "demo-status-check" {
  name = "demo-status-check"
}

resource "aws_sns_topic_subscription" "demo-status-check_lambda" {
  topic_arn = "${aws_sns_topic.demo-status-check.arn}"
  protocol  = "lambda"
  endpoint  = "${var.demo-status-check_lambda_arn}"
}

resource "aws_sns_topic_policy" "demo-status-check-TopicPolicy" {
  arn = "${aws_sns_topic.demo-status-check.arn}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigSNSPolicy20180201",
      "Action": [
        "SNS:Publish",
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.demo-status-check.arn}",
      "Principal": {
        "AWS": "*"
      },
      "Condition":{
         "StringEquals":{
            "AWS:SourceAccount":"${var.aws_account_id}"
          }
      }
    }
  ]
}
EOF
}
