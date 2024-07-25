resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.us_east_1a.id
  }
  tags       = merge({ Name = "nsse-production-vpc-private-route-table-1a" }, var.tags)
  depends_on = [aws_vpc.this]
}

resource "aws_route_table_association" "private_associations_1a" {
  count = length([for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1a"])

  subnet_id      = [for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1a"][0]
  route_table_id = aws_route_table.private_1a.id
  depends_on     = [aws_route_table.private_1a]
}


resource "aws_route_table" "private_1b" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.us_east_1b.id
  }
  tags       = merge({ Name = "nsse-production-vpc-private-route-table-1b" }, var.tags)
  depends_on = [aws_vpc.this]
}

resource "aws_route_table_association" "private_associations_1b" {
  count = length([for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1b"])

  subnet_id      = [for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1b"][0]
  route_table_id = aws_route_table.private_1b.id
  depends_on     = [aws_route_table.private_1b]
}
