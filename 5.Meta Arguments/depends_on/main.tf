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

resource "aws_s3_bucket" "bucket" {
  bucket = "47467464-depends-on"
  depends_on = [
    aws_instance.my_server
  ]
}

resource "aws_instance" "my_server" {
  ami           = "ami-04902260ca3d33422"
  instance_type = "t2.micro"

  tags = {
    Name = "MyServer"
  }
}

#show output
output "Public_IPv4" {
  value = aws_instance.my_server.public_ip
}