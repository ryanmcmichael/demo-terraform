# Internet gateway for the applciation VPC.
resource "aws_internet_gateway" "application" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.environment}-application-internet-gateway"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

