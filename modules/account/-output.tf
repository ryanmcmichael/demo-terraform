output "cloudtrail_sns_topic_arn" {
  value = "${aws_sns_topic.cloudtrail.arn}"
}

output "log_bucket_arn" {
  value = "${aws_s3_bucket.log.arn}"
}

output "log_bucket_id" {
  value = "${aws_s3_bucket.log.id}"
}

output "log_bucket_domain_name" {
  value = "${aws_s3_bucket.log.bucket_domain_name}"
}

output "instance_key_name" {
  value = "${aws_key_pair.terraform-demo.key_name}"
}