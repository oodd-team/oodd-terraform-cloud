# Prod CloudFront 설정
resource "aws_cloudfront_distribution" "frontend_prod_cf" {
  origin {
    domain_name = aws_s3_bucket.frontend_prod_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_prod_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "oodd prod cloudfront distribution"
  default_root_object = "index.html"

  # aliases = ["oodd.today"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.frontend_prod_bucket.id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # 지리적 제한: 특정 국가에서만 접근하도록 화이트리스트 작성
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.prod_cert.arn
    ssl_support_method       = "sni-only"     # SNI 기반 SSL 인증서 사용
    minimum_protocol_version = "TLSv1.2_2021" # 최소 SSL/TLS 버전
  }
  tags = {
    Name        = "prod-cloudfront"
    Environment = "prod"
  }
}

# Dev CloudFront 설정
resource "aws_cloudfront_distribution" "frontend_dev_cf" {
  origin {
    domain_name = aws_s3_bucket.frontend_dev_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_dev_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "oodd dev cloudfront distribution"
  default_root_object = "index.html"

  # aliases = ["dev.oodd.today"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.frontend_dev_bucket.id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # 지리적 제한: 특정 국가에서만 접근하도록 화이트리스트 작성
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.prod_cert.arn
    ssl_support_method       = "sni-only"     # SNI 기반 SSL 인증서 사용
    minimum_protocol_version = "TLSv1.2_2021" # 최소 SSL/TLS 버전
  }
  tags = {
    Name        = "dev-cloudfront"
    Environment = "dev"
  }
}