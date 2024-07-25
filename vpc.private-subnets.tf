resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.nsse_production_vpc.id
  cidr_block              = var.private_subnets[count.index].cidr_block
  availability_zone       = var.private_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.private_subnets[count.index].map_public_ip_on_launch
  tags                    = merge({ Name = var.private_subnets[count.index].name }, var.tags)
}
