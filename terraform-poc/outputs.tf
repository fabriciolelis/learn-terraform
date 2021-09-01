output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.test.address
  #   sensitive   = true
}


output "rds_endpoint" {
  description = "RDS instance hostname"
  value       = aws_db_instance.test.endpoint
  #   sensitive   = true
}
