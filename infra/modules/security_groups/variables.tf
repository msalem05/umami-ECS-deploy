variable "vpc_id" {
    type = string
}

variable "alb_http_sg_name" {
    type = string
    default = "umami_alb_allow-http"
}

variable "vpc_cidr" {
    type = string
}

variable "ecs_sg_name" {
    type = string
    default = "umami-ecs-sg"
}

variable "container_port" {
    type = number
    default = 3000
}

variable "db_port" {
    type = number
    default = 5432
}

variable "db_sg_name" {
    type = string
    default = "db-sg"
}
