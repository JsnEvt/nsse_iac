#Criando a base de criterios de avaliacao de requests
#as regras ainda serao adicionadas
resource "aws_wafv2_web_acl" "this" {
  name  = "waf-devopsnanuvem-com-webacl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "98-SuspiciousRequestFlagger"
    priority = 98

    rule_label {
      name = "nsse:suspicious:request"
    }
    #na verificacao a label e adicionada para mostrar que o request tem uma propriedade do tipo
    #da label escrita acima, como suspeito, por exemplo

    action {
      count {}
      #usando count, a verificacao continua e so no final das leituras da "pipeline" e decidido se bloqueia ou permite
    }

    statement {
      label_match_statement {
        scope = "NAMESPACE"
        #label das verificacoes das request gerenciadas pela aws
        #devido as regras gerenciadas pelo cloud provider
        key = "awswaf:managed:aws:"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "98-SuspiciousRequestFlaggerMetrics"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "99-CustomForbiddenResponse"
    priority = 99

    action {
      block {
        custom_response {
          response_code            = 403
          custom_response_body_key = "403-CustomForbiddenResponse"
        }
      }
    }
    #O statement e a camada/pipeline que verifica a possivel ameaca
    #esse trecho esta personalizado
    statement {
      label_match_statement {
        scope = "LABEL"
        key   = "nsse:suspicious:request"
        #como na regra anterior foi adicionada essa key, a acao seguinte e disparada bloqueando o acesso
        #em action/block, no bloco acima
        #em seguida e renderizado o custom_response_body no bloco abaixo
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "99-CustomForbiddenResponseMetrics"
      sampled_requests_enabled   = true
    }
  }
  #aqui esta sendo definido o corpo de resposta personalizado
  custom_response_body {
    key = "403-CustomForbiddenResponse"
    content = jsonencode({
      message = "You are not allowed to perform the action you requested."
    })
    content_type = "APPLICATION_JSON"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-devopsnanuvem-com-webacl-metrics"
    sampled_requests_enabled   = true
  }
}
