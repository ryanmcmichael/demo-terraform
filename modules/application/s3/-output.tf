output "config_bucket" {
  value = "${aws_s3_bucket.demo_config.bucket}"
}

output "config_bucket_arn" {
  value = "${aws_s3_bucket.demo_config.arn}"
}

output "lambda_functions_bucket" {
  value = "${aws_s3_bucket.lambda_functions.bucket}"
}

output "lambda_functions_bucket_arn" {
  value = "${aws_s3_bucket.lambda_functions.arn}"
}