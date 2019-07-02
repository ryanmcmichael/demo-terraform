resource "aws_s3_bucket" "lambda_functions" {
  bucket = "${var.account}-demo-lambda-functions"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${var.account}-LambdaFunctionsBucketPolicy",
  "Statement": [
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.account}-demo-lambda-functions/*",
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
      "Resource": "arn:aws:s3:::${var.account}-demo-lambda-functions/*",
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
        "arn:aws:s3:::${var.account}-demo-lambda-functions"
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

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "s3/lambda-functions/"
  }

  lifecycle {
    prevent_destroy = false
  }
}
