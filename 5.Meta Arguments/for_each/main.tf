terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.68.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "my_server" {
  for_each = {
    nano  = "t2.nano"
    micro="t2.micro"
    small="t2.micro"
  }
  ami           = "ami-04902260ca3d33422"
  instance_type = each.value

  tags = {
    Name = "MyServer"
  }
}

#show output
output "Public_IPv4" {
  value = values(aws_instance.my_server)[*].public_ip
}