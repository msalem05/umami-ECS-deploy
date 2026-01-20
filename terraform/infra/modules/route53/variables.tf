variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "acm_validation_name" {
  type = string
}

variable "acm_validation_record" {
  type = list(string)
}

variable "ttl" {
  type    = number
  default = 60
}