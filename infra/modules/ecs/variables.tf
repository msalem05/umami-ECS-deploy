variable "cluster_name" {
  type    = string
  default = "umami-ecs-cluster"
}

variable "task_family_name" {
  type    = string
  default = "umami-task"
}

variable "execution_role_arn" {
  type = string
  description = "ECS Task Execution Role ARN"
}

variable "task_role_arn" {
  type = string
  description = "ECS Task Role ARN"
}

variable "container_name" {
  type    = string
  default = "umami"
}

variable "image_repo_url" {
  description = "ECR Repo URL"
}

variable "task_cpu" {
  type    = number
  default = 1024
}

variable "task_memory" {
  type    = number
  default = 2048
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "alb_target_group_arn" {
}

variable "ecs_sg_name" {
  type    = string
  default = "umami_ecs_sg"
}

variable "vpc_id" {

}

variable "alb_sg_id" {

}

variable "ecs_subnet" {

}

variable "app_name" {
  type    = string
  default = "umami-service"
}

variable "alb_listener" {
}