resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.ec2_resources.key_pair_name
  public_key = tls_private_key.this.publi_key_openssh
  tags       = merge(var.tags, { name = var.ec2_resources.key_pair_name })
}
