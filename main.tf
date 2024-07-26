provider "aws" {
  region = var.region
  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}

//ISSO E PARA ATIVAR O STATE LOCKING NA TABELA DYNAMO PARA 
//QUE EM AMBIENTE COLABORATIVO, NAO SEJA POSSIVEL RODAR O APPLY AO MESMO
//TEMPO POR OUTRA PESSOA. (E UM TRAVAMENTO PARA EVITAR CORRUPCAO DE DADOS do *.tfstate)
//para que o tfstate saia do local e va para o S3, precisamos
//adicionar o bucket no codigo main.tf
//executando previamente o apply com o codigo do backend.terraform 
//o bucket e a tabela dynamo ja foram criadas.

//o comando terraform init -migrate-state transfere o arquivo *.tfstate para o S3

terraform {
  backend "s3" {
    bucket         = "nsse-terraform-state-bucket"
    key            = "networking/terraform.tfstate" //dara erro, caso nao seja criada primeiro. (comentar a linha)
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "nsse-terraform-state-lock-table"
  }
}
