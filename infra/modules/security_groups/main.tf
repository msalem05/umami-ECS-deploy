terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#ALB Security Group + Rules
resource "aws_security_group" "alb" {
  name        = var.alb_http_sg_name
  description = "Security group for ALB allowing HTTP and HTTPS inbound traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "alb_ingress_http" {
  type = "ingress"
  description = "Allow HTTP traffic from within the VPC"
  security_group_id = aws_security_group.alb.id
  from_port = 80
  to_port = 80
  cidr_blocks = [var.vpc_cidr]
  protocol = "tcp"
}

resource "aws_security_group_rule" "alb_ingress_https" {
  type = "ingress"
  description = "Allow HTTPS traffic from within the VPC"
  security_group_id = aws_security_group.alb.id
  from_port = 443
  to_port = 443
  protocol = "tcp"
}

resource "aws_security_group_rule" "alb_egress_ecs" {
  type = "egress"
  description     = "Allow Outbound Traffic to ECS Task"
  security_group_id = aws_security_group.alb.id
  from_port = var.container_port
  to_port = var.container_port
  source_security_group_id = aws_security_group.ecs_sg.id
  protocol = "tcp"
}

#ECS Task Security Group and Rules
resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_sg_name
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_ingress_alb" {
  type = "ingress"
  description     = "Allow inbound from ALB to ECS tasks on container port"
  security_group_id = aws_security_group.ecs_sg.id
  from_port = var.container_port
  to_port = var.container_port
  source_security_group_id = aws_security_group.alb.id
  protocol = "tcp"
}

resource "aws_security_group_rule" "ecs_egress_db" {
  type = "egress"
  description     = "Allow outbound traffic from ECS tasks to DB Instance"
  security_group_id = aws_security_group.ecs_sg.id
  from_port = var.db_port
  to_port = var.db_port
  source_security_group_id = aws_security_group.db_sg.id
  protocol = "tcp"
}

resource "aws_security_group_rule" "ecs_egress" {
  type = "egress"
  description = "Allow outbound traffic from ECS tasks to AWS services"
  security_group_id = aws_security_group.ecs_sg.id
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "tcp"
}

#DB Security Group + Rule
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "db_ingress" {
  type = "ingress"
  description     = "Allow PostgreSQL from ECS tasks"
  security_group_id = aws_security_group.db_sg.id
  from_port = 5432
  to_port = 5432
  source_security_group_id = aws_security_group.ecs_sg.id
  protocol = "tcp"
}
