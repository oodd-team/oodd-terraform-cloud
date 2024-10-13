output "dev_api_domain" {
  value = aws_route53_record.dev_api.fqdn
}

output "prod_api_domain" {
  value = aws_route53_record.prod_api.fqdn
}

output "dev_frontend_domain" {
  value = aws_route53_record.dev_frontend.fqdn
}

output "prod_frontend_domain" {
  value = aws_route53_record.prod_frontend.fqdn
}