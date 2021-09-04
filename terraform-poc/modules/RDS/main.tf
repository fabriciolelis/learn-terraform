data "aws_secretsmanager_secret_version" "mysecret" {
  secret_id = "Tf-test-secrets"

}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.mysecret.secret_string
  )
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
  username             = local.db_creds.username
  password             = local.db_creds.password
  parameter_group_name = aws_db_parameter_group.test.name
  port                 = 3306
  publicly_accessible  = true
  skip_final_snapshot  = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
