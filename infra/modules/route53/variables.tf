variable "record_name" {
  type    = string
  default = "alb_dns"
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "acm_validation_name" {

}

variable "acm_validation_record" {

}

variable "ttl" {
  type    = number
  default = 60
}