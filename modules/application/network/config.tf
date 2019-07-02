# Defines even smaller CIDR blocks by service
### NOTE: REFACTORING NECESSARY WHEN TRANSITIONING TO MULTI-REGION ###

#10.1.0.0/19
module "pub_cidr_block" {
  source = "../../pass-thru/"
  value = "${cidrsubnet(var.vpc_cidr_block, 3, 0)}"
}

#10.1.192.0/19
module "mgt_cidr_block" {
  source = "../../pass-thru/"
  value = "${cidrsubnet(var.vpc_cidr_block, 3, 6)}"
}

#10.1.224/19
module "build_cidr_block" {
  source = "../../pass-thru/"
  value = "${cidrsubnet(var.vpc_cidr_block, 3, 7)}"
}

module "database_cidr_block" {
  source = "../../pass-thru/"
  value = "${cidrsubnet(var.vpc_cidr_block, 3, 3)}"
}

#10.1.32.0/19
module "services_cidr_block" {
  source = "../../pass-thru/"
  value = "${cidrsubnet(var.vpc_cidr_block, 3, 1)}"
}