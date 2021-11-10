provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "./modules/vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "./modules/security-groups"
  name           = var.name
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "ecr" {
  source      = "./modules/ecr"
  name        = var.name
  environment = var.environment
}


module "alb" {
  source              = "./modules/alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  zone_id             = var.zone_id
  environment         = var.environment
  subdomain_name      = var.subdomain_name
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}


module "s3-admin-front" {
  source              = "./modules/s3"
  zone_id             = var.zone_id
  bucket_name         = var.bucket_name
  domain_name         = var.domain_name
  name                = var.name
  environment         = var.environment
  subdomain_name      = var.subdomain_name
  tsl_certificate_arn = var.tsl_certificatecloudfront
}

# module "s3-mobile-front" {
#   source              = "./modules/s3"
#   zone_id             = var.zone_id
#   bucket_name         = var.bucket_name
#   domain_name         = var.domain_name
#   name                = var.name
#   environment         = var.environment
#   subdomain_name      = var.subdomain_name
#   tsl_certificate_arn = var.tsl_certificatecloudfront
# }

module "mySQL-rds" {
  source              = "./modules/rds"
  name                = var.name
  environment         = var.environment
  subnets             = module.vpc.private_subnets
  rds_security_groups = [module.security_groups.rds_sg]
}

module "ecs" {
  source                      = "./modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks, module.security_groups.db_access_sg]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name  = "AWS_BUCKET_NAME",
      value = "scanecosystem-files"
    },
    { name  = "AWS_CLOUD_WATCH_STREAM",
      value = "scanecosystem-cloudwatch-logs"
    },
    {
      name  = "XMPP_HOST",
      value = "ejabberd.virtus-scan-ecosystem.com"
    },
    {
      name  = "XMPP_PORT",
      value = "5222"
    },
    {
      name  = "XMPP_DOMAIN",
      value = "ejabberd.virtus-scan-ecosystem.com"
    },
    {
      name  = "AWS_REGION",
      value = "us-east-2"
    },
    {
      name  = "TOKEN_VALIDITY_SECONDS",
      value = "86400"
    },
    {
      name  = "TOKEN_REMEBER_SECONDS",
      value = "86400"
    },
    {
      name  = "DATABASE_URL",
      value = module.mySQL-rds.hostname
    },
    {
      name  = "DATABASE_NAME",
      value = module.mySQL-rds.database-name
    }
  ]
  container_secrets      = var.container_secrets
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  container_secrets_arns = var.secrets_arn
  depends_on = [
    module.mySQL-rds
  ]
}

