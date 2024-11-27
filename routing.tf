# 기존에 있던 존 가져오기
data "aws_route53_zone" "prod_zone" {
  name = "oodd.today."
}

data "aws_acm_certificate" "server_cert"{
  domain = "api.oodd.today"
  provider = aws
}

data "aws_acm_certificate" "prod_cert" {
  domain   = "oodd.today"
  provider = aws.east
}

resource "aws_route53_record" "www_oodd_today" {
  zone_id = data.aws_route53_zone.prod_zone.zone_id
  name    = "www.oodd.today"
  type    = "CNAME"
  records = ["oodd.today"]
  ttl     = "300"
}

resource "aws_route53_record" "oodd_today" {
  name    = "oodd.today"
  zone_id = data.aws_route53_zone.prod_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_prod_cf.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_prod_cf.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.frontend_prod_cf]
}

resource "aws_route53_record" "dev_oodd_today" {
  name    = "dev.oodd.today"
  zone_id = data.aws_route53_zone.prod_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_dev_cf.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_dev_cf.hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_cloudfront_distribution.frontend_dev_cf]
}

# Route53에 서브도메인 레코드 생성: api.oodd.today
resource "aws_route53_record" "api_record" {
  zone_id = data.aws_route53_zone.prod_zone.zone_id
  name    = "api.oodd.today"
  type    = "A"

  alias {
    name                   = aws_lb.nestjs_alb.dns_name
    zone_id                = aws_lb.nestjs_alb.zone_id
    evaluate_target_health = true
  }
}

# Route53에 서브도메인 레코드 생성: new-api-dev.oodd.today
resource "aws_route53_record" "new_api_dev_record" {
  zone_id = data.aws_route53_zone.prod_zone.zone_id
  name    = "new-api-dev.oodd.today"
  type    = "A"

  alias {
    name                   = aws_lb.nestjs_alb.dns_name
    zone_id                = aws_lb.nestjs_alb.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "dev_frontend" {
#   zone_id = data.aws_route53_zone.prod_zone.zone_id
#   name    = "dev.oodd.today"
#   type    = "A"
#   alias {
#     name                   = aws_cloudfront_distribution.frontend_prod_cf.domain_name
#     zone_id                = aws_cloudfront_distribution.frontend_prod_cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
