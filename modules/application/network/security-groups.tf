#Forces the removal of all rules from the VPC default security group
resource "aws_default_security_group" "default" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lambda.id}"]
    self            = true
  }
}

# Setup the application default security group
resource "aws_security_group" "application" {
  name_prefix = "${var.environment}-application-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  #allow SSH traffic in
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.mgt.*.cidr_block}"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-application-security-group"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "database" {
  name_prefix = "${var.environment}-database-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/8"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-database-security-group"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lambda" {
  name_prefix = "${var.environment}-lambda-"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-lambda-security-group"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Defines a security group for the bastion ELB.

resource "aws_security_group" "bastion_elb" {
  name_prefix = "${var.environment}-bastion-elb-"
  vpc_id = "${var.vpc_id}"

  # WHITELIST IPS GO HERE
  ingress {
    from_port = "${var.bastion_elb_port}"
    to_port = "${var.bastion_elb_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${aws_subnet.mgt.*.cidr_block}"]
  }

  tags {
    Name        = "${var.environment}-bastion-elb-security-group"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Defines a security group for the bastion ASG.
### NOTE: NEEDS TO BE HARDENED ###

resource "aws_security_group" "bastion" {
  name_prefix = "${var.environment}-bastion-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-bastion-security-group"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}