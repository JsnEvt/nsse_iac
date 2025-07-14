//as configuracoes abaixo referem-se a construcao do patchbaseline dentro
//do systems manager
//a associacao e possivel verificar dentro do state manager
//ele associara o Document - RunPatchBaseline ao schedule expression (cronometro)
//e os targets para atualizacoes periodicas das instancias vinculadas
//o patch manager informa se as instancias ja estao com compliance
//o dashboard informara os dados acima

resource "aws_ssm_association" "debian_production" {
  name                = var.debian_production_association.name
  schedule_expression = var.debian_production_association.schedule_expression
  association_name    = var.debian_production_association.association_name
  max_concurrency     = var.debian_production_association.max_concurrency
  max_errors          = var.debian_production_association.max_errors

  parameters = {
    Operation    = var.debian_production_association.parameters.Operation
    RebootOption = var.debian_production_association.parameters.RebootOption
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.logs.bucket
    s3_key_prefix  = var.debian_production_association.output_location.s3_key_prefix
  }


  targets {
    key    = var.debian_production_association.targets.key
    values = [var.patch_group]
  }
}
