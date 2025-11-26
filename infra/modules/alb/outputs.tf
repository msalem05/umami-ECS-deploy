output "alb_target_group_arn" {
    description = "ARN of the ALB Target Group"
    value = aws_lb_target_group.umami_tg.arn
}

output "alb_sg_id" {
    description = "ID of the ALB SG"
    value = aws_security_group.alb.id
}

output "alb_dns_name" {
    value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
    value = aws_lb.alb.zone_id
}