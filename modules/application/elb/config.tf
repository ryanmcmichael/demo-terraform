# Load balancer for the bastion ASG.

resource "aws_elb" "bastion" {
  name = "${var.environment}-${var.project}-bastion"
  subnets = ["${split(",", var.public_subnet_ids)}"]
  security_groups = ["${var.bastion_elb_security_group_id}"]

  listener {
    lb_port = "${var.bastion_elb_port}"
    lb_protocol = "tcp"
    instance_port = 22
    instance_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 5
    target = "TCP:22"
    interval = 60
  }

  access_logs {
    bucket = "${var.log_bucket_id}"
    bucket_prefix = "elb/bastion"
  }

  internal = false
  cross_zone_load_balancing = true
  idle_timeout = 300
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "${var.environment}-${var.project}-bastion-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}