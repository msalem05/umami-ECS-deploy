variable "bucket_name" {
  type    = string
  default = "umami-tfstate"
}

variable "retention_days" {
  type    = number
  default = 30
}

variable "alb_logs_bucket_name" {
  type    = string
  default = "alb-access-logs"
}

variable "deletion_window" {
  type    = number
  default = 30
}