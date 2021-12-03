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
  alias = "east"
}
provider "aws" {
  profile = "default"
  region  = "us-west-1"
  alias = "west"
}

data "aws_ami" "east-amazon-linux" {
    provider = aws.east
  most_recent      = true
  owners           = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
data "aws_ami" "west-amazon-linux" {
    provider = aws.west
  most_recent      = true
  owners           = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "my_east_server" {
  ami           = "${data.aws_ami.east-amazon-linux.id}"
  instance_type = "t2.micro"
provider = aws.east
  tags = {
    Name = "MyEastServer"
  }
}
resource "aws_instance" "my_west_server" {
  ami           = "${data.aws_ami.west-amazon-linux.id}"
  instance_type = "t2.micro"
provider = aws.west
  tags = {
    Name = "MyWestServer"
  }
}

#show output
output "east_Public_IPv4" {
  value = aws_instance.my_east_server.public_ip
}
output "west_Public_IPv4" {
  value = aws_instance.my_west_server.public_ip
}