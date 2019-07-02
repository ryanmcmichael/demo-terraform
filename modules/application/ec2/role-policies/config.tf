resource "aws_iam_role_policy" "list_all_buckets" {
  name    = "${var.environment}-${var.name}-list-all-buckets"
  role    = "${var.role_id}"
  policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Id" : "ListAllBuckets",
  "Statement": [
    {
      "Sid": "AllowAllBucketListing",
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    }
  ]
}
POLICY

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "config_bucket" {
  name    = "${var.environment}-${var.name}-config-bucket"
  role    = "${var.role_id}"
  policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Id" : "Config",
  "Statement": [
    {
      "Sid": "AllowGettingFromConfigBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:GetBucketLocation",
        "s3:ListObjects",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::${var.config_bucket}",
        "arn:aws:s3:::${var.config_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": [
        "${var.ini_kms_key_arn}"
      ]
    }
  ]
}
POLICY

  lifecycle {
    create_before_destroy = true
  }
}
