terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "ecs_task_execution" {
  name = var.ecs_task_execution_policy_name
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = var.ecr_repo_arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${var.cw_log_group_arn}:*"
      }
    ]
  })
}

data "aws_caller_identity" "account_id" {

}

resource "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task" {
  name = var.ecs_task_policy_name
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = "arn:aws:rds-db:eu-west-2:${data.aws_caller_identity.account_id}:dbuser:${var.db_id}/${var.db_username}:"
      }
    ]
  })
}

