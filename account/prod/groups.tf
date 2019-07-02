resource "aws_iam_group" "admins" {
  name = "${var.account}-administrators"
  path = "/users/"
}

resource "aws_iam_group_policy" "admins" {
  name = "${var.account}-administrators"
  group = "${var.account}-administrators"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_group" "s3_admins" {
  name = "${var.account}-s3-administrators"
  path = "/users/"
}

resource "aws_iam_group_policy" "s3_admins" {
  name = "${aws_iam_group.s3_admins.name}"
  group = "${aws_iam_group.s3_admins.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_group" "ssh_users" {
  name = "${var.account}-${var.environment}-ssh-users"
  path = "/users/"
}
