resource "aws_iam_role" "server" {
  name                = "${var.environment}-${var.name}"
  assume_role_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "server" {
  name    = "${var.environment}-${var.name}"
  role    = "${aws_iam_role.server.id}"
  policy  = "${var.role_policy}"

  lifecycle {
    create_before_destroy = true
  }
}

module "server_role_policies" {
  config_bucket = "${var.config_bucket}"
  environment = "${var.environment}"
  ini_kms_key_arn = "${var.ini_kms_key_arn}"
  name = "${var.name}"
  role_id = "${aws_iam_role.server.id}"
  source = "../role-policies"
}

resource "aws_iam_instance_profile" "server" {
  name        = "${aws_iam_role.server.name}"
  roles       = ["${aws_iam_role.server.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "server" {
  name_prefix           = "${var.environment}-${var.name}-"
  image_id              = "${var.image_id}"
  instance_type         = "${var.instance_type}"
  security_groups       = ["${split(",", var.security_group_ids)}"]
  iam_instance_profile  = "${aws_iam_instance_profile.server.name}"
  ebs_optimized         = "${var.ebs_optimized_instances}"
  key_name              = "${var.instance_key_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  user_data             = "${var.user_data}"


  lifecycle {
    create_before_destroy = true
  }
}

