provider "aws" {
  region = var.region
}


resource "aws_db_parameter_group" "test" {
  name   = "test"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

resource "aws_db_instance" "test" {
  identifier           = "my-db-test"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  name                 = "mydbtest"
  username             = "admin"
  password             = "admin123"
  parameter_group_name = aws_db_parameter_group.test.name
  port                 = 3306
  skip_final_snapshot  = true
}


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
