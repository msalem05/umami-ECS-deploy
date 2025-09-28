module "s3" {
    source = "./modules/s3"
    bucket_name = "umami-tfstate"
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    az = var.az 

}

module "ecr" {
    source = "./modules/ecr"
}

module "iam" {
    source = "./modules/iam"
    ecr_repository_arn = module.ecr.repository_arn
}
