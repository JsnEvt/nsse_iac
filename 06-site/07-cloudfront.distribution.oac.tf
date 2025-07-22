#OAC Origin Access Control - Controle de acesso aos arquivos estaticos do bucket. Quando tentamos acessar a 
#pagina web, temos Acess Denied, porque o Cloudfront ainda nao tem permissao para aessar
#o S3. Ele visa assinar a requisicao para indicar que a requisicao realmente esta vindo do cloudfront

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${aws_s3_bucket.site.bucket_regional_domain_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

