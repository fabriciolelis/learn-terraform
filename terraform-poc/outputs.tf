output "aws_alb_target_group_arn" {
  value = module.alb.aws_alb_target_group_arn
}

output "aws_ecr_repository_url" {
  value = module.ecr.aws_ecr_repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "executionRoleArn" {
  value = module.ecs.executionRoleArn
}

output "taskRoleArn" {
  value = module.ecs.taskRoleArn
}
