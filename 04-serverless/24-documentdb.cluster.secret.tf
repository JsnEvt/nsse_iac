//essa operacao de criacao do secrets e necessaria para que o documentdb possa 
//ter uma senha de acesso atrelada ao secrets manager
//esse documentdb servira para geracao dos relatorios dentro da aplicacao web

resource "aws_secretsmanager_secret" "documentdb" {
  name = var.document_db_cluster.secret_name
  tags = var.tags
}

//para gerar uma secret aleatoria
data "aws_secretsmanager_random_password" "documentdb" {
  password_length     = 30
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret_version" "first" {
  secret_id = aws_secretsmanager_secret.documentdb.id
  secret_string = jsondecode({
    secret_string = var.document_db_cluster.master_username
    password      = data.aws_secretsmanager_random_password.documentdb.random_password
  })
  //para evitar renovacao a cada terraform apply:
  lifecycle {
    ignore_changes = [secret_string]
  }
}
