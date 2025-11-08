variable "alb_name" {
    type = string
    default = "umami-alb"
}

variable "vpc_id" {

}

variable "alb_http_sg_name" {
    type = string
    default = "umami_alb_allow-http"
}

variable "vpc_cidr" {

}

variable "alb_ssh_sg_name" {
    type = string
    default = "umami_alb_allow-ssh"
}

variable "alb_subnet" {
    type = list(string) 
}

variable "ssl_policy" {
    type = string
    default = "ELBSecurityPolicy-2016-08"
}

variable "tg_name" {
    type = string
    default = "umami-alb-tg"
}

variable "health_check_healthy_threshold" {
    type = number
    default = 5
}

variable "health_check_unhealthy_threshold" {
    type = number
    default = 2
}

variable "tg_port" {
    type = number
    default = 3000
}

variable "health_check_interval" {
    type = number 
    default = 15
}

variable "health_check_path" {
    type = string
    default = "/"
}

variable "health_check_protocol" {
    type = string
    default = "HTTP"
}

variable "health_check_timeout" {
    type = number
    default = 5
}

variable "health_check_matcher" {
    type = string
    default = "200-399"
}

variable "certificate_arn" {
    type = string
}
