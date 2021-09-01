provider "aws" {
  profile = "default"
  region  = "us-east-2"

  default_tags {
    tags = {
      Environment = "Test"
      Service     = "Example"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Service   = "Custom"
    ManagedBy = "Resource"
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "learn-terraform-aws-default-tags-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

data "aws_default_tags" "current" {}

resource "aws_autoscaling_group" "example" {
  availability_zones = data.aws_availability_zones.available.names
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
