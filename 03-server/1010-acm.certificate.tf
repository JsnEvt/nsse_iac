#INICIANDO AS CONFIGURACOES PARA USO DO INGRESS
#INGRESS = ROTEADOR INTERNO PARA AS APLICACOES/O MESMO TAMBEM IRA INTERAGIR COM O CLOUD PROVIDER
#E CRIAR O APPLICATION LOAD BALANCER
#AQUI O CERTIFICADO SERA GERADO PELO CLOUD PROVIDER
#Em Route53 na AWS, Registered domains e possivel registrar um dominio para usar aqui.

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain
  validation_method = "DNS"

  tags = var.tags
}

#apos a criacao do certificado, precisamos valida-lo. 
#obtendo o data.route53.hosted-zone do arquivo .terraform

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      # zone_id = dvo.domain_name == "example.org" ? data.aws_route53_zone.example_org.zone_id : data.aws_route53_zone.example_com.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}







