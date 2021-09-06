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
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
}

module "ecs" {
  source                      = "./modules/ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "AWS_BUCKET_NAME",
    value = "scanecosystem-files" },
    { name = "AWS_CLOUD_WATCH_STREAM",
    value = "scanecosystem-cloudwatch-logs" },
    {
      name = "ADMIN_DOMAIN_NAME",
      value = "admin.virtus-scan-ecosystem.com"
    },
    {
      name = "XMPP_HOST",
      value = "ejabberd.virtus-scan-ecosystem.com"
    },
    {
      name = "XMPP_PORT",
      value = "5222"
    },
    {
      name = "XMPP_DOMAIN",
      value = "ejabberd.virtus-scan-ecosystem.com"
    },
    {
      name = "AWS_REGION",
      value = "us-east-2"
    },
    {
      name = "TOKEN_VALIDITY_SECONDS",
      value = "86400"
    },
    {
     name = "TOKEN_REMEBER_SECONDS",
     value = "86400"
    }
  ]
  # container_secrets      = module.secrets.secrets_map
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  # container_secrets_arns = module.secrets.application_secrets_arn
}

# module "mySQL-db" {
#   source = "./modules/RDS"
# }



# module "db" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "~> 3.0"

#   identifier = "testdb"

#   engine            = "mysql"
#   engine_version    = "8.0.23"
#   instance_class    = "db.m5.large"
#   allocated_storage = 20

#   name     = "testdb"
#   username = "user"
#   password = "YourPwdShouldBeLongAndSecure!"
#   port     = "3306"

#   vpc_security_group_ids = ["sg-12345678"]

#   maintenance_window = "Mon:00:00-Mon:03:00"
#   backup_window      = "03:00-06:00"

#   # Enhanced Monitoring - see example for details on how to create the role
#   # by yourself, in case you don't want to create it automatically
#   monitoring_interval    = "30"
#   monitoring_role_name   = "MyRDSMonitoringRole"
#   create_monitoring_role = true

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }

#   # DB subnet group
#   subnet_ids = ["subnet-12345678", "subnet-87654321"]

#   # DB parameter group
#   family = "mysql8.0"

#   # DB option group
#   major_engine_version = "8.0"

#   # Database Deletion Protection
#   deletion_protection = false
# }
