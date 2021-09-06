resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = "${var.name}-task-${var.environment}"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.name}-container-${var.environment}"
    image     = aws_ecr_repository.main.repository_url
    essential = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecsTaskRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [ "dynamodb:CreateTable",
         "dynamodb:UpdateTimeToLive",
         "dynamodb:PutItem",
         "dynamodb:DescribeTable",
         "dynamodb:ListTables",
         "dynamodb:DeleteItem",
         "dynamodb:GetItem",
         "dynamodb:Scan",
         "dynamodb:Query",
         "dynamodb:UpdateItem",
         "dynamodb:UpdateTable" 
        ],
        Effect = "Allow"
        Resource = "*"
        },
      ]
    })
  }

  tags = {
    tag-key = "tag-value"
  }
}

# This role regulates what AWS services the task has access
# resource "aws_iam_role" "ecs_task_role" {
#   name = "${var.name}-ecsTaskRole"

#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    },
#    {
#      "Effect": "Allow",
#      "Action": [
#          "dynamodb:CreateTable",
#          "dynamodb:UpdateTimeToLive",
#          "dynamodb:PutItem",
#          "dynamodb:DescribeTable",
#          "dynamodb:ListTables",
#          "dynamodb:DeleteItem",
#          "dynamodb:GetItem",
#          "dynamodb:Scan",
#          "dynamodb:Query",
#          "dynamodb:UpdateItem",
#          "dynamodb:UpdateTable"
#      ],
#      "Sid": "",
#      "Resource": "*"
#    }
#  ]
# }
# EOF
# }

# resource "aws_iam_policy" "mypolicy-test" {
#   name        = "${var.name}-task-policy-mypolicy-test"
#   description = "Test policy from Terraform execution"

#   policy = <<EOF
# {
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": [
#                "dynamodb:CreateTable",
#                "dynamodb:UpdateTimeToLive",
#                "dynamodb:PutItem",
#                "dynamodb:DescribeTable",
#                "dynamodb:ListTables",
#                "dynamodb:DeleteItem",
#                "dynamodb:GetItem",
#                "dynamodb:Scan",
#                "dynamodb:Query",
#                "dynamodb:UpdateItem",
#                "dynamodb:UpdateTable"
#            ],
#            "Resource": "*"
#        }
#    ]
# }
#   EOF
# }

# resource "aws_iam_policy_attachment" "ecs-task-role-policy-attachment" {
#   name       = "${var.name}-ecs-task-role-policy-attachment"
#   roles      = [aws_iam_role.ecs_task_role.name]
#   policy_arn = aws_iam_policy.mypolicy-test.arn
# }

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "main" {
  name                               = "${var.name}-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
