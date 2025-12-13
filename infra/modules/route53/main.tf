data "aws_route53_zone" "zone" {
    name = "msalem-umami.com"
}

resource "aws_route53_record" "alb_dns" {
    zone_id = data.aws_route53_zone.zone.zone_id
    name = "msalem-umami.com"
    type = "A"

    alias {
        name = var.alb_dns_name
        zone_id = var.alb_zone_id
        evaluate_target_health = true
    }
}

resource "aws_route53_record" "acm_validation" {
    zone_id = data.aws_route53_zone.zone.zone_id
    name = var.acm_validation_name
    records = var.acm_validation_record
    type = "CNAME"
    allow_overwrite = true
    ttl = var.ttl
}