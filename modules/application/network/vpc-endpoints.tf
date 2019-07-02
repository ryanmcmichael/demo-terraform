#Private endpoint to S3 so that we don't have to go out the front door to get there
/*resource "aws_vpc_endpoint" "application" {
  vpc_id = "${var.vpc_id}"
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = ["${aws_route_table.nat.*.id}"]
}*/

