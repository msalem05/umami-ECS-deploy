resource "aws_lb" "alb" {
    name = var.alb_name
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = var.alb_subnet

    enable_deletion_protection = true



}

resource "aws_security_group" "alb" {
    name = var.alb_http_sg_name
    description = "Allowing HTTP and HTTPS Inbound Traffic"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.vpc_cidr
        
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.vpc_cidr

    }


}

resource "aws_security_group" "alb_ssh" {
    name = var.alb_ssh_sg_name
    description = "Allowing SSH Inbound Traffic"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.vpc_cidr
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_listener" "alb_listener_https" {
    load_balancer_arn = aws_lb.alb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = var.ssl_policy
    certificate_arn = var.certificate_arn

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.umami_tg.arn
    }
}

resource "aws_lb_target_group" "umami_tg" {
    name = var.tg_name
    target_type = "alb"
    port = var.tg_port
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = var.health_check_path 
      protocol = var.health_check_protocol
      enabled = true
      healthy_threshold = var.health_check_healthy_threshold
      unhealthy_threshold = var.health_check_unhealthy_threshold
      interval = var.health_check_interval
      timeout = var.health_check_timeout
      matcher = var.health_check_matcher
    }

}