variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  default     = "prod"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  default     = 1
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 80
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 512
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  default     = "arn:aws:acm:us-east-2:534327908844:certificate/9d961a18-55c0-4230-ba64-9504d902c9c3"
}

# Use the only one certificate if the region of application deployment is us-east-1. Because Cloudfront only accepts certificates 
# at us-east-1
variable "tsl_certificatecloudfront" {
  description = "The ARN of the certificate that the Cloudfront uses."
  default     = "arn:aws:acm:us-east-1:534327908844:certificate/1644962e-749d-4a71-8081-f1c1c41f56a1"
}

variable "domain_name" {
  default = "terraform.virtus-scan-ecosystem.com"
}

variable "bucket_name" {
  default = "terraform.virtus-scan-ecosystem.com"
}

variable "mobile_front_domain" {
  default = "terraform.virtus-scan-ecosystem.com"
}

variable "mobile_front_bucket" {
  default = "terraform.virtus-scan-ecosystem.com"
}

variable "zone_id" {
  default = "Z02482001VOV03ZD0ZJTJ"
}

variable "container_secrets" {
  default = [
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:XMPPSecretTest-ureepd:username::",
      name      = "XMPP_USERNAME"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:XMPPSecretTest-ureepd:password::",
      name      = "XMPP_PASSWORD"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:SESSecretTest-rYqcnz:password::",
      name      = "EMAIL_PASSWORD"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:SESSecretTest-rYqcnz:username::",
      name      = "EMAIL_USERNAME"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:AWSSecretTest-sLdRcW:awsAccessKeyId::",
      name      = "AWS_ACCESS_KEY_ID"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:AWSSecretTest-sLdRcW:awsSecretKey::",
      name      = "AWS_SECRET_KEY"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:Tf-test-secrets-wOPH4c:username::",
      name      = "DATABASE_USERNAME"
    },
    {
      valueFrom = "arn:aws:secretsmanager:us-east-2:534327908844:secret:Tf-test-secrets-wOPH4c:password::",
      name      = "DATABASE_PASSWORD"
    }
  ]
}

variable "secrets_arn" {
  default = ["arn:aws:secretsmanager:us-east-2:534327908844:secret:Tf-test-secrets-wOPH4c",
    "arn:aws:secretsmanager:us-east-2:534327908844:secret:AWSSecretTest-sLdRcW",
    "arn:aws:secretsmanager:us-east-2:534327908844:secret:SESSecretTest-rYqcnz",
    "arn:aws:secretsmanager:us-east-2:534327908844:secret:XMPPSecretTest-ureepd"
  ]
}

variable "database_secret_arn" {
  default = "arn:aws:secretsmanager:us-east-2:534327908844:secret:Tf-test-secrets-wOPH4c"
}

variable "subdomain_name" {
  default = "virtus.com"
}
