locals {
  public_subnet_1a_id = one([for subnet in aws_subnet.publics : subnet.id if subnet.availability_zone == "us-east-1a"])
  public_subnet_1b_id = one([for subnet in aws_subnet.publics : subnet.id if subnet.availability_zone == "us-east-1b"])
}

resource "aws_subnet" "publics" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.public_subnets[count.index].map_public_ip_on_launch

  tags = merge({
    Name = "${var.vpc_resources.vpc}-${var.public_subnets[count.index].name}",
    //a tag abaixo e para ser encontrada pelo AWS Load Balancer Controller do kubernetes
    //a tag foi excluida pois o load balancer agora e internal, na rede privada
    //a tag foi para o vcp-private-subnets.tf
  }, var.tags)
  depends_on = [aws_vpc.this]
}
