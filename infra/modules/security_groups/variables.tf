variable "vpc_id" {
    type = string
}

variable "alb_http_sg_name" {
    type = string
    default = "umami_alb_allow-http"
}

variable "vpc_cidr" {

}

variable "ecs_sg_name" {
    type = string
}

variable "container_port" {
    type = string
}

variable "db_port" {
    type = number
}

variable "db_sg_id" {
    type = string
}

variable "db_sg_name" {
    type = string
}
