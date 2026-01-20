terraform {
  backend "s3" {
    bucket     = "umami-tfstate"
    key        = "terraform.tfstate"
    region     = "eu-west-2"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-2:622703418024:key/ecf5fc0c-08a7-4728-803c-344ebe5bad9f"
  }
}