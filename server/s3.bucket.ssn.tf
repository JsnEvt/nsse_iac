//s3 para troca de arquivos entre o bucket e o ansible - instrucoes da documentacao

resource "aws_s3_bucket" "ansible_ssm" {
  bucket = var.bucket_ssm
  tags   = var.tags
}
