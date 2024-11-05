

terraform {
  required_version = ">=1.9.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.74.0"
    }
  }
  backend "remote" {
    organization = "Shanks_practice"
    workspaces {
      name = "terra_practice"
    }
  }
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

#terraform {
#  backend "s3" {
#  bucket = "mybackendbucket"
#  key    = "practice/terraform.tfstate"
#  region = "ap-south-1"
#}
#}

resource "aws_security_group" "allow_sg" {
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"
  tags = {
    Name:"newEc2"
  }
  vpc_security_group_ids = [aws_security_group.allow_sg.id]

}

#data"aws_instance" "my_ec2" {
#  filter {
#    name   = "tag:Name"
#    values = ["newEc2"]
#  }
#
#}
#
#output "ec2_details" {
#  value = [data.aws_instance.my_ec2.ami,data.aws_instance.my_ec2.public_ip]
#}