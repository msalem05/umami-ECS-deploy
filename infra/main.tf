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
  source           = "./modules/iam"
  ecr_repo_arn     = module.ecr.repository_arn
  db_id            = module.db.db_id
  db_username      = var.db_username
  cw_log_group_arn = module.ecs.cw_log_group_arn
}

module "db" {
  source                       = "./modules/rds"
  subnet_ids                   = module.vpc.private_subnet_id
  db_sg_id                     = module.security_groups.db_sg_id
  enhanced_monitoring_role_arn = module.iam.enhanced_monitoring_role_arn

  depends_on = [module.iam]
}

module "acm" {
  source = "./modules/acm"
}

module "acm_validation" {
  source                = "./modules/acm_validation"
  dns_validation_record = module.route53.dns_validation_record
  acm_certificate_arn   = module.acm.certificate_arn
}

module "alb" {
  source          = "./modules/alb"
  certificate_arn = module.acm.certificate_arn
  vpc_id          = module.vpc.vpc_id
  alb_subnets     = module.vpc.public_subnet_id
  alb_logs_bucket = module.s3.alb_logs_bucket
  alb_sg_id       = module.security_groups.alb_sg_id
}

module "ecs" {
  source               = "./modules/ecs"
  ecs_subnet           = module.vpc.private_subnet_id
  image_repo_url       = module.ecr.repository_url
  task_role_arn        = module.iam.task_role_arn
  execution_role_arn   = module.iam.execution_role_arn
  alb_target_group_arn = module.alb.alb_target_group_arn
  ecs_sg_id            = module.security_groups.ecs_sg_id

  depends_on = [module.alb]
}

module "route53" {
  source                = "./modules/route53"
  alb_dns_name          = module.alb.alb_dns_name
  alb_zone_id           = module.alb.alb_zone_id
  acm_validation_record = module.acm.acm_validation_record
  acm_validation_name   = module.acm.acm_validation_name
}

module "security_groups" {
  source   = "./modules/security_groups"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
}