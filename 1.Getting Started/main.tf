terraform {

backend "remote" {
    hostname = "app.terraform.io"
    organization = "Blitz504"

    workspaces {
      name = "getting-started"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

/*
provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias = "eu"
}
*/

variable "instance_type" {
  type = string
}

#local variable
locals {
  project_name="blitz"
}

resource "aws_instance" "my_server" {
  ami           = "ami-04902260ca3d33422"
  instance_type = var.instance_type

  tags = {
    Name = "MyServer-${local.project_name}"
  }
}

/*
#VPC module from terraform registry provided by AWS
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

providers = {
  aws = aws.eu
 }

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
*/

#show output
output "Public_IPv4" {
  value = aws_instance.my_server.public_ip
}