terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

  }
}

provider "aws" {
  alias  = "west"
  region = "eu-west-2"
}