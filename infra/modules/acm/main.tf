terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "msalem-umami.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [var.dns_validation_record]
}