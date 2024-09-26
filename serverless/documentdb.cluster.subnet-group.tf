resource "aws_docdb_subnet_group" "this" {
  name       = "nsse-documentdb-subnet-group"
  subnet_ids = [data.aws_subnets.private_subnets.id]

  tags = merge(var.tags, {
    Name = "nsse-documentdb-sunbet-group"
  })
}
