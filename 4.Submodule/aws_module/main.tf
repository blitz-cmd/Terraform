terraform {
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

# locals {
#   ami= "ami-04902260ca3d33422"
# }

#For dynamic refernce of AMI
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

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

#show output
output "Public_IPv4" {
  value = aws_instance.my_server.public_ip
}