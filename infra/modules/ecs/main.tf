resource "aws_ecs_cluster" "umami_cluster" {
    name = var.cluster_name

    setting {
        name = "containerInsights"
        value = "enabled"
    }
}

resource "aws_ecs_task_definition" "umami_ecs_task" {
    family = var.task_family_name
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    execution_role_arn = var.execution_role_arn
    task_role_arn = var.task_role_arn
    cpu = var.task_cpu
    memory = var.task_memory
    container_definitions = jsonencode([
        {
            name = var.container_name
            image = "${var.image_repo_url}:latest"
            essential = true
            portMappings = [
                {
                    containerPort = var.container_port
                    protocol = "tcp"

                }
            ]

        }
    ])
}

resource "aws_security_group" "ecs_sg" {
    name = var.ecs_sg_name
    description = "Allow Inbound Traffic From Container Port"
    vpc_id = var.vpc_id

    ingress {
        from_port = var.container_port
        to_port = var.container_port
        protocol = "tcp"
        security_groups = [ var.alb_sg_id ]
    }

    egress {
        from_port =  0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_ecs_service" "umami_ecs_service" {
    name = var.app_name
    cluster = aws_ecs_cluster.umami_cluster.id
    task_definition = aws_ecs_task_definition.umami_ecs_task.id
    desired_count = var.desired_count
    launch_type = "FARGATE"

    load_balancer {
      target_group_arn = var.alb_target_group_arn
      container_name = var.container_name
      container_port = var.container_port
    }

    network_configuration {
      subnets = var.ecs_subnet
      security_groups = [ aws_security_group.ecs_sg.id ]
    }

    depends_on = [ var.alb_listener ]
}