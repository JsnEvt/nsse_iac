resource "aws_vpc" "nsse_production_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  tags                 = merge({ Name = "nsse-production-vpc" }, var.tags)
}

