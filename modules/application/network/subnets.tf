
# Defines a series of subnets used for mgt based on the count parameter, the list of zones
# from environment-variables.tf, and the CIDR blocks from network-variables.tf

resource "aws_subnet" "mgt" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${var.zone_count}"
  cidr_block              = "${cidrsubnet(module.mgt_cidr_block.value, 2, count.index)}"
  #10.10.0.0/24 10.10.1.0/24 10.10.2.0/24
  availability_zone       = "${element(split(",", var.zones), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.environment}-mgt-${element(split(",", var.zones), count.index)}-subnet"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Defines a subnet for public functionality. CIDR blocks defined in network-variables.tf

resource "aws_subnet" "pub" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${var.zone_count}"
  cidr_block              = "${cidrsubnet(module.pub_cidr_block.value, 2, count.index)}"
  availability_zone       = "${element(split(",", var.zones), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.environment}-pub-${element(split(",", var.zones), count.index)}-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "database" {
  vpc_id                  = "${var.vpc_id}"
  count                   = 2
  cidr_block              = "${cidrsubnet(module.database_cidr_block.value, 2, count.index)}"
  availability_zone       = "${element(split(",", var.zones), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.environment}-database-${element(split(",", var.zones), count.index)}-subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_db_subnet_group" "database" {
  name = "${var.environment}-database"
  description = "Subnets for RDS creation"
  subnet_ids = ["${aws_subnet.database.*.id}"]

  tags {
    Name = "${var.environment}-database"
  }
}

resource "aws_subnet" "services" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${var.zone_count}"
  cidr_block              = "${cidrsubnet(module.services_cidr_block.value, 2, count.index)}"
  availability_zone       = "${element(split(",", var.zones), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.environment}-services-${element(split(",", var.zones), count.index)}-subnet"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

