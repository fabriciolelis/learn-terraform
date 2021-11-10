region                    = "us-west-2"
environment               = "dev"
availability_zones        = ["us-west-2a", "us-west-2b", "us-west-2c"]
cidr                      = "10.0.0.0/16"
private_subnets           = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
public_subnets            = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
service_desired_count     = 1
container_port            = 8080
container_cpu             = 512
container_memory          = 2048
health_check_path         = "/"
tsl_certificate_arn       = "arn:aws:acm:us-west-2:534327908844:certificate/b6bbb574-a7d4-424b-b32d-e7096ec6b6a2"
tsl_certificatecloudfront = "arn:aws:acm:us-east-1:534327908844:certificate/1644962e-749d-4a71-8081-f1c1c41f56a1"
domain_name               = "marketplace"
bucket_name               = "marketplace-bucket"
subdomain_name            = "virtus-scan-ecosystem.com"
zone_id                   = "Z02482001VOV03ZD0ZJTJ"
container_secrets = [
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:XMPP-Secrets-vyPxhn:username::",
    name      = "XMPP_USERNAME"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:XMPP-Secrets-vyPxhn:password::",
    name      = "XMPP_PASSWORD"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:SES-Secrets-h8S8ba:password::",
    name      = "EMAIL_PASSWORD"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:SES-Secrets-h8S8ba:username::",
    name      = "EMAIL_USERNAME"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:AWS-Secrets-dVGF3n:awsAccessKeyId::",
    name      = "AWS_ACCESS_KEY_ID"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:AWS-Secrets-dVGF3n:awsSecretKey::",
    name      = "AWS_SECRET_KEY"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:Database-Secrets-9emXJb:username::",
    name      = "DATABASE_USERNAME"
  },
  {
    valueFrom = "arn:aws:secretsmanager:us-west-2:534327908844:secret:Database-Secrets-9emXJb:password::",
    name      = "DATABASE_PASSWORD"
  }
]
secrets_arn = [
  "arn:aws:secretsmanager:us-west-2:534327908844:secret:Database-Secrets-9emXJb",
  "arn:aws:secretsmanager:us-west-2:534327908844:secret:XMPP-Secrets-vyPxhn",
  "arn:aws:secretsmanager:us-west-2:534327908844:secret:SES-Secrets-h8S8ba",
  "arn:aws:secretsmanager:us-west-2:534327908844:secret:AWS-Secrets-dVGF3n"
]

database_secret_arn = "arn:aws:secretsmanager:us-west-2:534327908844:secret:Database-Secrets-9emXJb"
