output "db_sg_id" {
    value = aws_security_group.db_sg.id
}

output "ecs_sg_id" {
    value = aws_security_group.ecs_sg.id
}

output "alb_sg_id" {
    value = aws_security_group.alb.id
}