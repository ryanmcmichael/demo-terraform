
# We output the management CIDR block for module users.
output "mgt_cidr_block" {
  value = "${module.mgt_cidr_block.value}"
}

output "mgt_subnet_ids" {
  value = "${join(",", aws_subnet.mgt.*.id)}"
}

output "nat_route_table_ids" {
  value = "${join(",", aws_route_table.nat.*.id)}"
}

output "pub_subnet_ids" {
  value = "${join(",", aws_subnet.pub.*.id)}"
}

output "database_subnet_ids" {
  value = "${join(",", aws_subnet.database.*.id)}"
}

output "database_security_group_id" {
  value = "${aws_security_group.database.id}"
}

output "database_subnet_group_name" {
  value = "${aws_db_subnet_group.database.name}"
}

output "services_subnet_ids" {
  value = "${join(",", aws_subnet.services.*.id)}"
}

output "lambda_security_group_id" {
  value = "${aws_security_group.lambda.id}"
}

output "bastion_security_group_id" {
  value = "${aws_security_group.bastion.id}"
}