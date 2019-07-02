resource "aws_s3_bucket" "demo_config" {
  bucket = "${var.account}-demo-config"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${var.account}-ConfigBucketPolicy","Statement": [
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.account}-demo-config/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": ["AES256", "aws:kms"]
        }
      }
    },
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.account}-demo-config/*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    },
    {
      "Sid": "DenyUnsecureTransport",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.account}-demo-config"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": false
        }
      }
    }
  ]
}
POLICY

  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "s3/config/"
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}
