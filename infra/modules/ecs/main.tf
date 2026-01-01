terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_ecs_cluster" "umami_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "umami_ecs_task" {
  family                   = var.task_family_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.image_repo_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"

        }
      ]

    }
  ])
}

resource "aws_ecs_service" "umami_ecs_service" {
  name            = var.app_name
  cluster         = aws_ecs_cluster.umami_cluster.id
  task_definition = aws_ecs_task_definition.umami_ecs_task.id
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    subnets         = var.ecs_subnet
    security_groups = [var.ecs_sg_id]
  }
}

resource "aws_cloudwatch_log_group" "ecs_cw_logs" {
  name = var.cw_log_group_name
  retention_in_days = var.retention_in_days
  kms_key_id = aws_kms_key.cw_logs.arn
}

data "aws_caller_identity" "account" {

}

resource "aws_kms_key" "cw_logs" {
  description = "KMS key for ECS Cloudwatch Logs" 
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.account.account_id}:root"
        }
        Action = "kms:*"
        Resource = "*"
      },

      {
        Effect = "Allow"
        Principal = {
          Service = "logs.eu-west-2.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}