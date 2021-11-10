variable "domain_name" {
  description = "Domain name"
}

variable "bucket_name" {
  description = "Bucket name"
}

variable "zone_id" {
  description = "Zone ID"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "subdomain_name" {
  description = "subdomain_name"
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

