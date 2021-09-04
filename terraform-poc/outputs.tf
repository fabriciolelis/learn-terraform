# output "rds_hostname" {
#   description = "ARN of the bucket"
#   value       = module.mySQL-db.hostname
# }

# output "rds_endpoint" {
#   description = "Name (id) of the bucket"
#   value       = module.mySQL-db.endpoint
# }

output "aws_ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

