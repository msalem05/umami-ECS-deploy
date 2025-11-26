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