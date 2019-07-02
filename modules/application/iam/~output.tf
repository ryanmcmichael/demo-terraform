output "lambda_common_role_arn" {
  value = "${aws_iam_role.lambda_common_role.arn}"
}

output "demo_rds_role_arn" {
  value = "${aws_iam_role.demo_rds_role.arn}"
}