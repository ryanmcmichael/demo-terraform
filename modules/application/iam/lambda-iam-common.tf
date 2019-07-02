#COMMON

resource "aws_iam_role" "lambda_common_role" {
  name = "lambda-common-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "essentials-common" {
  role       = "${aws_iam_role.lambda_common_role.name}"
  policy_arn = "${aws_iam_policy.lambda_essentials_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "vpc-execution-common" {
  role = "${aws_iam_role.lambda_common_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "basic-execution-common" {
  role = "${aws_iam_role.lambda_common_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sns-common" {
  role = "${aws_iam_role.lambda_common_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

# POLICIES

resource "aws_iam_policy" "lambda_essentials_policy" {
  name = "lambda-essentials-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueAttributes",
        "sqs:GetQueueUrl",
        "sqs:Send*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sns:List*",
        "sns:Get*",
        "sns:Publish",
        "sns:Subscribe"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

