resource "aws_nat_gateway" "us_east_1a" {
  allocation_id = aws_eip.nat_gateway_1a.id
  subnet_id     = [for subnet in aws_subnet.publics : subnet.id if subnet.availability_zone == "us-east-1a"][0]
  tags          = merge({ Name = "nsse-production-vpc-nat-gateway-1a" }, var.tags)
  depends_on    = [aws_eip.nat_gateway_1a]
}

resource "aws_nat_gateway" "us_east_1b" {
  allocation_id = aws_eip.nat_gateway_1b.id
  subnet_id     = [for subnet in aws_subnet.publics : subnet.id if subnet.availability_zone == "us-east-1b"][0]
  tags          = merge({ Name = "nsse-production-vpc-nat-gateway-1b" }, var.tags)
  depends_on    = [aws_eip.nat_gateway_1b]
}
