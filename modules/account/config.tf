resource "aws_key_pair" "terraform-demo" {
  key_name   = "terraform-demo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaY0Uh2f/UDR3gLBeIjiPqLsxgZQpAz3wHK5os5esTdCtx+khHI7sPkmt3ZliAtfDALPgh2Pa8A5pFRbMUcVJp0X0YyzpPPMxPM0h4nvA1IOiUuCQL/MejDc3WXvSU9bOkMojfsp9jAWImIoh++6oF9aev9Bmuht3JhDK5NpaXaB1QewtbGC9qHybIdZGyGzgRcsn1ApnugJNMfBethnSJwuaZmgt0Xi1HoaE6bM2ms/Gmj484GZbVeZ3vLttGSy619DXPxzo4I3FdH/noyyWqepkvLP6BxEBZTtAUHfDhCKhFSmD7hepOHnPdNd7vMHEcp8c1ERy7+QRuUB/zfOiF"
}

resource "aws_iam_account_password_policy" "account" {
  allow_users_to_change_password = true
  max_password_age = 30
  minimum_password_length = 30
  password_reuse_prevention = 24
  require_lowercase_characters = true
  require_numbers = true
  require_symbols = true
  require_uppercase_characters = true
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "log" {
  bucket = "${var.account}-demo-log"
  acl = "log-delivery-write"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.account}-demo-log"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.account}-demo-log/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSServiceWrite",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.account}-demo-log/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY


  lifecycle_rule {
    id = "log"
    prefix = "/"
    enabled = true

    transition {
      days = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}
