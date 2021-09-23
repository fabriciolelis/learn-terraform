// Create a variable for our domain name because we'll be using it a lot.
variable "domain_name" {
  default = "terraform.virtus-scan-ecosystem.com"
}

variable "bucket_name" {
  default = "terraform.virtus-scan-ecosystem.com"
}

// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  default = "virtus-scan-ecosystem.com"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}


variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default     = "arn:aws:acm:us-east-1:534327908844:certificate/1644962e-749d-4a71-8081-f1c1c41f56a1"
}
