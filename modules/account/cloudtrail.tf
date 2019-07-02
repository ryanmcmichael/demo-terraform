resource "aws_sns_topic" "cloudtrail" {
  name = "${var.account}-demo-cloudtrail"
  display_name = "AWSCloudTrail"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailSNSPolicy",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:${var.region}:${var.aws_account_id}:${var.account}-demo-cloudtrail"
    }
  ]
}
POLICY
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.account}-cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.log.id}"
  s3_key_prefix                 = "cloudtrail"
  enable_logging                = true
  include_global_service_events = true
  is_multi_region_trail         = true
  sns_topic_name                = "${aws_sns_topic.cloudtrail.name}"
}