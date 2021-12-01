terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

resource "aws_key_pair" "terra_key" {
  key_name   = "terra_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6MYcA27Kp7FS4+GJ+olGXPx+99z5i3JnzYrALbG6EMgkbzIRirgOnkO8sP8zqduddujyAJXFCnLxRKzClADtxxP+v7MI3ERQeDb7o4ucrkxP4DhkfwlxA3XVCbeVryc9an2W2dcHpMZWT4xr43yIJnVdZwLZSB3kCsWiAzpxTOrLcMNXi7G6YRGb8+SEYD8Fw1H6ageuLRJW3SvQ0FNwcpApOhQeJB0x0w5rd+ZOWHjOG0PqyNpBzWZ4gpb6FFYC7m5x7KQiiR85/XM6mwI5hYF0eaPYpokhnKDwlFcSiVARpZ7garw7cIJ8hV/UUFo6gHFOHv7yl0PGGfuHjqLTDT9Ll238Qw3TuP7by64xNWMcMRXHHRXxDPijNKLJXgHO8B8/0VewibynHNOJT4+EdDEUiA5jgfbxBpcAqp/eyODPpfWoT3t1AgNu9CN+Hm49Ouze8nnbUOKpDqqC04RKtLPabx1UQJC9sn1tVIG9FfaxPAfAqhrq9NbBkS7UKTC0= deep@BLITZ"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-06e50849b300ce22b"
}

data "template_file" "user_data"{
template=file("./userdata.yml")
}

resource "aws_security_group" "terra_sg" {
  name        = "terra_sg"
  description = "My SG"
  vpc_id      = data.aws_vpc.main.id

  ingress =[{
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  },
  {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }]

  egress {
  description = "Outbound rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }
}

resource "aws_instance" "my_server" {
  ami           = "ami-04902260ca3d33422"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terra_key.key_name
  vpc_security_group_ids = [ aws_security_group.terra_sg.id ]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = "MyServer"
  }
}

output "Public_IPv4" {
  value = aws_instance.my_server.public_ip
}