resource "aws_iam_role" "config" {
  name = "${var.account}-config"
  path = "/system/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAWSConfigAssume",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "config" {
  name = "${var.account}-config"
  roles = ["${aws_iam_role.config.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_sns_topic" "config" {
  name = "${var.account}-demo-config"
  display_name = "AWSConfig"
  policy = <<POLICY
{
  "Statement": [
    {
      "Sid": "AWSConfigSNSPolicy",
      "Action": [
        "SNS:Publish"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sns:${var.region}:${var.aws_account_id}:${var.account}-demo-config",
      "Principal": {
        "Service": [
          "config.amazonaws.com"
        ]
      }
    }
  ]
}
POLICY
}