# resource "aws_route53_record" "dev_api" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "api-dev.oodd.today"
#   type    = "A"
#   alias {
#     name                   = aws_lb.dev_alb.dns_name
#     zone_id                = aws_lb.dev_alb.zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_route53_record" "prod_api" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "api.oodd.today"
#   type    = "A"
#   alias {
#     name                   = aws_lb.prod_alb.dns_name
#     zone_id                = aws_lb.prod_alb.zone_id
#     evaluate_target_health = true
#   }
# }

# 기존에 있던 존 가져오기
data "aws_route53_zone" "prod_zone" {
  name = "oodd.today."
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
