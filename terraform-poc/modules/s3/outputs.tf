output "s3_bucket_name" {
  value = aws_s3_bucket.root_bucket.id
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.root_bucket.bucket_domain_name
}

output "domain_name" {
  value = aws_route53_record.root-a.name
}