resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.nsse_production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nsse_production_vpc_internet_gateway.id
  }
  tags = merge({ Name = "nsse-production-vpc-public-route-table" }, var.tags)
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
