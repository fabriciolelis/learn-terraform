output "hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.test.address
  #   sensitive   = true
}

output "endpoint" {
  description = "RDS instance hostname"
  value       = aws_db_instance.test.endpoint
  #   sensitive   = true
}
