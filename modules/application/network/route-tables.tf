resource "aws_route_table" "nat" {
  vpc_id = "${var.vpc_id}"
  count = "${var.zone_count}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-public.*.id, count.index)}"
  }

  tags {
    Name        = "${var.environment}-nat-${count.index}-subnet-route-table"
    Environment = "${var.environment}"
  }
}

# Route table for public traffic in/out of the public subnet

resource "aws_route_table" "pub" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.application.id}"
  }

  tags {
    Name        = "${var.environment}-pub-subnet-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "services" {
  vpc_id = "${var.vpc_id}"
  count = "${var.zone_count}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-public.*.id, count.index)}"
  }

  tags {
    Name        = "${var.environment}-services-${count.index}-subnet-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "mgt" {
  count = "${var.zone_count}"
  subnet_id = "${element(aws_subnet.mgt.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, count.index)}"
}


resource "aws_route_table_association" "pub" {
  count = "${var.zone_count}"
  subnet_id = "${element(aws_subnet.pub.*.id, count.index)}"
  route_table_id = "${aws_route_table.pub.id}"
}

resource "aws_route_table_association" "services" {
  count = "${var.zone_count}"
  subnet_id = "${element(aws_subnet.services.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.services.*.id, count.index)}"
}
