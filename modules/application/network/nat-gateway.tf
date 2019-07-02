# create a NAT gateway per zone.
# EIP for the NAT gateway.

resource "aws_eip" "nat-public" {
  count = "${var.zone_count}"
  vpc = true
}

resource "aws_nat_gateway" "nat-public" {
  depends_on = ["aws_internet_gateway.application"]
  count = "${var.zone_count}"
  allocation_id = "${element(aws_eip.nat-public.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.pub.*.id, count.index)}"
}
