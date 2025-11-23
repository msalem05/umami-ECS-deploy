output "alb_target_group_arn" {
    description = "ARN of the ALB Target Group"
    value = aws_lb_target_group.umami_tg.arn
}

output "alb_sg" {
    description = "ID of the ALB SG"
    value = aws_security_group.alb.id
}