output "certificate_arn" {
  value = aws_acm_certificate.alb_cert.arn
}

output "acm_validation_name" {
  value = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_name
}

output "acm_validation_record" {
  value = [tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_value]
}