resource "aws_internet_gateway" "nsse_production_vpc_internet_gateway" {
  vpc_id = aws_vpc.nsse_production_vpc.id
  tags   = merge({ Name = "nsse-production-vpc-igw" }, var.tags)
}
