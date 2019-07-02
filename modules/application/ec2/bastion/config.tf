module "bastion_launch_configuration" {
  image_id                  = "${var.bastion_image_id}"
  config_bucket             = "${var.config_bucket}"
  environment               = "${var.environment}"
  ini_kms_key_arn           = "${var.ini_kms_key_arn}"
  instance_key_name         = "${var.instance_key_name}"
  instance_type             = "${var.instance_type}"
  name                      = "bastion"
  region                    = "${var.region}"
  associate_public_ip_address = "false"
  role_policy               = <<POLICY
{
  "Version": "2012-10-17",
  "Id" : "BastionPolicy",
  "Statement": [
    {
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
  security_group_ids        = "${var.security_group_ids}"
  source                    = "../launch-config"
  user_data                 = <<USER_DATA
#!/bin/bash

#ensure pip and awscli are latest
pip install --upgrade pip
ln -sf /usr/local/bin/pip /usr/bin/pip
pip install --upgrade awscli
USER_DATA
}

resource "null_resource" "wait_for" {

  provisioner "local-exec" {
    command = "echo 'Waited for creation to complete'"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  depends_on = ["null_resource.wait_for"]
  name = "${module.bastion_launch_configuration.launch_configuration_name}"
  vpc_zone_identifier = ["${split(",", var.pub_subnet_ids)}"]
  max_size = 1
  min_size = 1
  health_check_grace_period = 600
  health_check_type = "EC2"
  load_balancers = ["${var.bastion_elb_name}"]
  launch_configuration = "${module.bastion_launch_configuration.launch_configuration_name}"

  tag {
    key = "Name"
    value = "${var.environment}-bastion"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
