terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_lb" "alb" {
  name                       = var.alb_name
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = var.alb_subnet
  drop_invalid_header_fields = true

  enable_deletion_protection = true

  access_logs {
    bucket  = var.alb_logs_bucket
    enabled = true
  }
}

# resource "aws_security_group" "alb" {
#   name        = var.alb_http_sg_name
#   description = "Security group for ALB allowing HTTP and HTTPS inbound traffic"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "Allow HTTP traffic from within the VPC"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

#   ingress {
#     description = "Allow HTTPS traffic from within the VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

#   egress {
#     description     = "Allow Outbound Traffic to ECS Task"
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "alb_ssh" {
#   name        = var.alb_ssh_sg_name
#   description = "Security group for SSH access"
#   vpc_id      = var.vpc_id

#   ingress {
#     description = "Allow SSH from within the VPC"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.umami_tg.arn
  }
}

resource "aws_lb_target_group" "umami_tg" {
  name        = var.tg_name
  target_type = "ip"
  port        = var.tg_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    matcher             = var.health_check_matcher
  }

}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
