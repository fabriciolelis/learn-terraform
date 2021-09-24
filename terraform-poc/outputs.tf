output "aws_alb_target_group_arn" {
  value = module.alb.aws_alb_target_group_arn
}

output "alb_domain_name" {
  value = module.alb.alb_domain_name
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

output "bucket_name" {
  value = module.s3-static-site.s3_bucket_name
}
output "bucket_domain_name" {
  value = module.s3-static-site.s3_bucket_domain_name
}

output "static_pages_domain" {
  value = module.s3-static-site.domain_name
}