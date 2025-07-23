resource "aws_cloudfront_distribution" "this" {
  enabled             = var.cloudfront.enabled
  default_root_object = var.cloudfront.default_root_object
  price_class         = var.cloudfront.price_class
  aliases             = [var.cloudfront.domain]

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
