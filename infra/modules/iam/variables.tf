variable "ecs_task_role_name" {
  type    = string
  default = "ecs_task"
}

variable "ecs_task_execution_role_name" {
  type    = string
  default = "ecs_task_execution"
}

variable "ecs_task_policy_name" {
  type    = string
  default = "task-policy"
}

variable "ecs_task_execution_policy_name" {
  type    = string
  default = "task_execution_policy"
}

variable "ecr_repo_arn" {
  type = string
}

variable "cw_log_group_arn" {
  type = string
}

variable "db_id" {
  type = string
}

variable "db_username" {
  type = string
}
