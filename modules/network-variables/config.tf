# Defines the master CIDR block for the environment

variable "demo_cidr_block" {
  description = "The base subnet"
  type        = "string"
  default     = "10.0.0.0/8"
}


# Defines larger CIDR blocks by region
# cidrsubnet syntax: https://www.terraform.io/docs/configuration/interpolation.html
### NOTE: REFACTORING NECESSARY WHEN TRANSITIONING TO MULTI-REGION ###

variable "region_cidr_newnums" {
  description = "The region indexes"
  type        = "map"
  default     = {
    eu-west-2 = 0
    #10.0.0.0/10
    us-west-1 = 1
    #10.64.0.0/10
    us-east-1 = 2
    #10.128.0.0/10
    reserved  = 3
    #10.192.0.0/10
  }
}

module "region_cidr_block" {
  source = "../pass-thru/"
  value = "${cidrsubnet(var.demo_cidr_block, 2, lookup(var.region_cidr_newnums, var.region))}"
}


# Defines smaller CIDR blocks by env
### NOTE: REFACTORING NECESSARY WHEN TRANSITIONING TO MULTI-REGION ###

variable "env_cidr_newnums" {
  description = ""
  type        = "map"
  default     = {
    prod    = 0
    #10.0.0.0/16  10.64.0.0/16  10.128.0.0/16 10.192.0.0/16
    stage    = 1
    #10.1.0.0/16  10.65.0.0/16  10.129.0.0/16 10.193.0.0/16
    dev      = 2
    #10.2.0.0/16 10.66.0.0/16  10.130.0.0/16 10.194.0.0/16
    test    = 3
    #10.3.0.0/16 10.67.0.0/16  10.131.0.0/16 10.195.0.0/16
    reserved    = 4
    #10.4.0.0/16 10.68.0.0/16  10.132.0.0/16 10.196.0.0/16
  }
}

module "env_cidr_block" {
  source = "../pass-thru/"
  value = "${cidrsubnet(module.region_cidr_block.value, 6, lookup(var.env_cidr_newnums, var.environment))}"
}
