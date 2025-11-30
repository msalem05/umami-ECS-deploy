data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
          type = "Service"
          identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }

}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = var.ecs_task_execution_role_name
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

}

data "aws_iam_policy_document" "ecs_task_execution" {
    statement {
        effect = "Allow"
        actions = [
            "ecr:GetAuthorizationToken",
        ]
        resources = ["*"]
    }

    statement {
        effect = "Allow"
        actions = [
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchCheckLayerAvailability"
        ]
        resources = [var.ecr_repository_arn]
    }
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
    name = var.ecs_task_execution_policy_name
    policy = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_role" "ecs_task_role" {
    name = var.ecs_task_role_name
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_task" {
    statement {
        effect = "Allow"
        actions = []
        resources = ["*"]
    }
}

resource "aws_iam_policy" "ecs_task_policy" {
    name = var.ecs_task_policy_name
    policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
    role = aws_iam_role.ecs_task_role.name
    policy_arn = aws_iam_policy.ecs_task_policy.arn
}