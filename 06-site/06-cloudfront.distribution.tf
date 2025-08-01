resource "aws_cloudfront_distribution" "this" {
  enabled             = var.cloudfront.enabled
  default_root_object = var.cloudfront.default_root_object
  price_class         = var.cloudfront.price_class
  aliases             = [var.cloudfront.domain]
  web_acl_id          = aws_wafv2_web_acl.this.arn

  #VPC ORIGIN - MEDIDA DE SEGURANCA/EDGE LOCATIONS
  origin {
    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.alb.id
    }
    origin_id   = aws_cloudfront_vpc_origin.alb.id
    domain_name = data.aws_lb.this.dns_name
  }

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = aws_s3_bucket.site.bucket_regional_domain_name
  }

  default_cache_behavior {
    allowed_methods  = var.cloudfront.default_cache_behavior.allowed_methods
    cached_methods   = var.cloudfront.default_cache_behavior.cached_methods
    target_origin_id = aws_s3_bucket.site.bucket_regional_domain_name

    #Managed-CachingOptimized
    cache_policy_id        = var.cloudfront.default_cache_behavior.cache_policy_id
    viewer_protocol_policy = var.cloudfront.default_cache_behavior.viewer_protocol_policy
  }

  /*nossa configuracao de cloudfront tem dois direcionamentos a saber:
1 - s3 - frontend
2 - alb - backend (que redireciona para o cluster)
o behaviors visa encaminhar a request para o local apropridado
path-pattern
*/
  dynamic "ordered_cache_behavior" {
    for_each = var.cloudfront.ordered_cache_behaviors
    content {
      path_pattern             = ordered_cache_behavior.value.path_pattern
      allowed_methods          = ordered_cache_behavior.value.allowed_methods
      cached_methods           = ordered_cache_behavior.value.cached_methods
      target_origin_id         = aws_cloudfront_vpc_origin.alb.id
      cache_policy_id          = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
      viewer_protocol_policy   = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only" #extensao do protocolo TLS / IP DEDICADO POR EDGE LOCATION 
    #no caso de gerenciamento de dominio por edge location - seria muito caro
    #entao a resolucao se dara de forma economica atraves do SNI - SERVER NAME INDICATION
    #sendo compartilhado com outros dominios. 
  }
}
