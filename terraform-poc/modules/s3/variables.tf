// Create a variable for our domain name because we'll be using it a lot.
variable "domain_name" {
  description = "domaint to access the page"
}

variable "bucket_name" {
  description = "bucket name to save tha static files"
}

// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  description = "root domain used to access the site"
}

variable "cloudfront_certificate" {
  description = "The ARN of the certificate that uses for https"
}

variable "zone_id" {
  description = "ID from hosted zone"
}