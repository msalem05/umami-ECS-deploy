output "cw_log_group_arn" {
    value = aws_cloudwatch_log_group.ecs_cw_logs.arn
}