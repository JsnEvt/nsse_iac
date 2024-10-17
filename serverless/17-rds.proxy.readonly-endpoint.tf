/*
criacao de um outro endpoint que sera para ser lido como leitura dentro do proxy
visto que requisicoes de gravacao como: insert, put, delete... usarao o endpoint de gravacao
e requisicoes do tipo select ou query usarao o endpoint de leitura.
eis o motivo da criacao deste recurso.
*/

resource "aws_db_proxy_endpoint" "read_only" {
  db_proxy_name          = aws_db_proxy.this.name
  db_proxy_endpoint_name = var.rds_proxy.read_only_endpoint
  vpc_subnet_ids         = data.aws_subnets.private_subnets.ids
  vpc_security_group_ids = [aws_security_group.postgresql.id]
  target_role            = "READ_ONLY"
}

