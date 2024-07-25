resource "aws_route_table" "private_route_table_1a" {
  vpc_id = aws_vpc.nsse_production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_1a.id
  }
  tags = merge({ Name = "nsse-production-vpc-private-route-table-1a" }, var.tags)
}

resource "aws_route_table_association" "private_route_table_association_1a" {
  count          = length([for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone == "us-east-1a"])
  subnet_id      = [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone == "us-east-1a"][0]
  route_table_id = aws_route_table.private_route_table_1a.id
}


resource "aws_route_table" "private_route_table_1b" {
  vpc_id = aws_vpc.nsse_production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_1b.id
  }
  tags = merge({ Name = "nsse-production-vpc-private-route-table-1b" }, var.tags)
}

resource "aws_route_table_association" "private_route_table_association_1b" {
  count          = length([for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone == "us-east-1b"])
  subnet_id      = [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone == "us-east-1b"][0]
  route_table_id = aws_route_table.private_route_table_1b.id
}
