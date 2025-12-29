terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_security_group" "alb" {
  name        = var.alb_http_sg_name
  description = "Security group for ALB allowing HTTP and HTTPS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from within the VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Allow HTTPS traffic from within the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description     = "Allow Outbound Traffic to ECS Task"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks     = [aws_security_group.ecs_sg.id]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = var.ecs_sg_name
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow inbound from ALB to ECS tasks on container port"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description     = "Allow outbound traffic from ECS tasks to RDS Instance"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.db_sg_id]
  }

  egress {
    description = "Allow outbound traffic from ECS tasks to AWS services"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }
}

