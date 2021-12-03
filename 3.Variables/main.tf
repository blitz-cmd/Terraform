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

variable "instance_type" {
  type = string
  description="The EC2 instance type"
#   sensitive=true
  validation {
    condition     = can(regex("^t3.",var.instance_type))
    error_message = "The instance type must be of t3."
  }
}

resource "aws_instance" "my_server" {
  ami           = "ami-04902260ca3d33422"
  instance_type = var.instance_type
}

#show output
output "Public_IPv4" {
  value = aws_instance.my_server.public_ip
  sensitive = true
}