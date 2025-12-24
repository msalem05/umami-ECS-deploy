terraform {
  backend "s3" {
    bucket = "umami-tfstate"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}