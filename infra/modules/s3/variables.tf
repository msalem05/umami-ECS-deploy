variable "bucket_name" {
    type = string
    default = "umami-tfstate"
}

variable "retention_days" {
    type = number
    default = 30
}