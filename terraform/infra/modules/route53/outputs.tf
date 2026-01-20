output "dns_validation_record" {
  value = aws_route53_record.acm_validation.fqdn
}