module "s3" {
  source      = "./modules/s3"
  bucket_name = "umami-tfstate"
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az

}

module "ecr" {
  source = "./modules/ecr"
}

module "iam" {
  source = "./modules/iam"
}

module "db" {
  source         = "./modules/rds"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_id
  ecs_task_sg_id = module.ecs.ecs_task_sg_id

}

module "acm" {
  source                = "./modules/acm"
  dns_validation_record = module.route53.dns_validation_record

}

module "alb" {
  source          = "./modules/alb"
  certificate_arn = module.acm.certificate_arn
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = var.vpc_cidr
  alb_subnet      = module.vpc.public_subnet_id
  alb_logs_bucket = module.s3.alb_logs_bucket

}

module "ecs" {
  source               = "./modules/ecs"
  vpc_id               = module.vpc.vpc_id
  ecs_subnet           = module.vpc.private_subnet_id
  image_repo_url       = module.ecr.repository_url
  task_role_arn        = module.iam.task_role_arn
  execution_role_arn   = module.iam.execution_role_arn
  alb_sg_id            = module.alb.alb_sg_id
  alb_target_group_arn = module.alb.alb_target_group_arn
}

module "route53" {
  source                = "./modules/route53"
  alb_dns_name          = module.alb.alb_dns_name
  alb_zone_id           = module.alb.alb_zone_id
  acm_validation_record = module.acm.acm_validation_record
  acm_validation_name   = module.acm.acm_validation_name
}