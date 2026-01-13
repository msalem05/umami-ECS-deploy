output "task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

# output "enhanced_monitoring_role_arn" {
#   value = aws_iam_role.rds_enhanced_monitoring.arn
# }

# output "enhanced_monitoring_policy_attachment_id" {
#   value = aws_iam_role_policy_attachment.rds_enhanced_monitoring.id
# }