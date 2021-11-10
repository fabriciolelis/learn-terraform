terraform {
  backend "s3" {
    bucket               = "terraform-states-scanecosystem"
    workspace_key_prefix = "template"
    key                  = "terraform.tfstate"
    region               = "us-east-2"
  }
}
