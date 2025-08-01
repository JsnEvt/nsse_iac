locals {
  private_subnet_1a_id = one([for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1a"])
  private_subnet_1b_id = one([for subnet in aws_subnet.privates : subnet.id if subnet.availability_zone == "us-east-1b"])
}

resource "aws_subnet" "privates" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index].cidr_block
  availability_zone       = var.private_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.private_subnets[count.index].map_public_ip_on_launch

  //mudanca da tag para buscar nas subnets privadas. o load balancer agora e internal
  tags = merge({ Name = "${var.vpc_resources.vpc}-${var.private_subnets[count.index].name}",
    "kubernetes.io/role/internal-elb" = "1",
  }, var.tags)
  depends_on = [aws_vpc.this]
}
