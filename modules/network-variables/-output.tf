# We output the region CIDR block for module users
output "region_cidr_block" {
  value = "${module.region_cidr_block.value}"
}

# We output the environment CIDR block for module users
output "environment_cidr_block" {
  value = "${module.env_cidr_block.value}"
}

output "corporate_cidr_block" {
  value = "${cidrsubnet(cidrsubnet(var.demo_cidr_block, 2, lookup(var.region_cidr_newnums, "eu-west-2")), 6, lookup(var.env_cidr_newnums, "corp"))}"
}
