data "aws_subnet" "private_subnets" {
  filter {
    name   = "tag:vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }
}
