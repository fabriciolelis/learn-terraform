output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}

output "alb_domain_name" {
  value = aws_route53_record.test.name
}