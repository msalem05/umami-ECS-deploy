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

