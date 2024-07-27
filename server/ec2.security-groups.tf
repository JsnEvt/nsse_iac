resource "aws_security_group" "allow_shh" {
  name        = var.ec2_resources.ssh_security_groups
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.this.id


  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ec2_resources.ssh_source_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { name = var.ec2_resources.ssh_security_groups })
}
