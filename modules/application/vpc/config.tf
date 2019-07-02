# Application VPC. Retrieves CIDR blocks from env variables.
resource "aws_vpc" "application" {
  cidr_block = "${var.environment_cidr_block}"
  instance_tenancy = "${var.instance_tenancy}"
  enable_dns_hostnames = true

  tags {
    Name        = "${var.environment}-vpc-application"
    Environment = "${var.environment}"
  }
}


