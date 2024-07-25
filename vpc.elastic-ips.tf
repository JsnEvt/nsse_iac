resource "aws_eip" "nat_gateway_1a" {
  domain = "vpc"
  tags   = merge({ Name = "nsse-production-eip-nat-gateway-1a" }, var.tags)
}

resource "aws_eip" "nat_gateway_1b" {
  domain = "vpc"
  tags   = merge({ Name = "nsse-production-eip-nat-gateway-1b" }, var.tags)
}
