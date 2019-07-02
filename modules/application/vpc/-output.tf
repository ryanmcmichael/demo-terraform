output "vpc_cidr_block" {
  value = "${aws_vpc.application.cidr_block}"
}

output "vpc_default_network_acl_id" {
  value = "${aws_vpc.application.default_network_acl_id}"
}

output "vpc_id" {
  value = "${aws_vpc.application.id}"
}
