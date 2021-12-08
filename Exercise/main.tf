terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.68.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-east-1"
}

#Configuring VPC
resource "aws_vpc" "tf-vpc" {
  cidr_block       = "30.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "tf-vpc"
  }
}

#Configuring Internet Gateway
resource "aws_internet_gateway" "tf-ig" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "tf-ig"
  }
}

#Configuring Public Subnet
resource "aws_subnet" "tf-pub-sub" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "30.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "tf-pub-sub"
  }
}

#Configuring Private Subnet
resource "aws_subnet" "tf-pri-sub" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "30.0.40.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "tf-pri-sub"
  }
}

#Configuring Public Route Table
resource "aws_route_table" "tf-pub-r" {
  vpc_id = aws_vpc.tf-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-ig.id  
    }
  tags = {
    Name = "tf-pub-r"
  }
}

#Configuring Subnet Association with Route Table
resource "aws_route_table_association" "tf-pub-r-a" {
  subnet_id      = aws_subnet.tf-pub-sub.id
  route_table_id = aws_route_table.tf-pub-r.id
}

#Configuring Public Route Table
resource "aws_route_table" "tf-pri-r" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "tf-pri-r"
  }
}

#Configuring Subnet Association with Route Table
resource "aws_route_table_association" "tf-pri-r-a" {
  subnet_id      = aws_subnet.tf-pri-sub.id
  route_table_id = aws_route_table.tf-pri-r.id
}

variable "personal-ip" {
  type = string
}

#Configuring EC2 Security Group
resource "aws_security_group" "tf-ec2-sg" {
  name        = "tf-ec2-sg"
  description = "My EC2 SG"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress = [{
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${var.personal-ip}/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${var.personal-ip}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
  }]

  egress {
    description      = "Outbound rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

#Finding AMI using filters for EC2
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}

#Configuring Instance
resource "aws_instance" "TF" {
  ami                         = data.aws_ami.amazon.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "poi"
  subnet_id                   = aws_subnet.tf-pub-sub.id
  security_groups             = ["${aws_security_group.tf-ec2-sg.id}"]
  user_data                   = <<-EOF
		#!/bin/bash
    sudo su
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html> <h1> Response coming from server </h1> </ html>" > /var/www/html/index.html
	EOF
  tags = {
    Name = "TF"
  }
}

#Configuring RDS Security Group
resource "aws_security_group" "tf-rds-sg" {
  name        = "tf-rds-sg"
  description = "My RDS SG"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress = [{
    description      = "MYSQL/Aurora"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["${aws_instance.TF.private_ip}/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  egress {
    description      = "Outbound rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

variable "username" {
  type = string
}
variable "password" {
  type = string
}

#Configuring Private Subnet 2
resource "aws_subnet" "tf-pri2-sub" {
  vpc_id     = aws_vpc.tf-vpc.id
  cidr_block = "30.0.30.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "tf-pri2-sub"
  }
}

#Configuring DB Subnet Group
resource "aws_db_subnet_group" "rds-subnet" {
  name       = "rds-subnet"
  subnet_ids = [aws_subnet.tf-pri-sub.id,aws_subnet.tf-pri2-sub.id]

  tags = {
    Name = "My RDS DB subnet group"
  }
}

#Configuring MySQL RDS
resource "aws_db_instance" "TF-RDS" {
  allocated_storage    = 20
  storage_type         = "gp2"
  port                 = "3306"
  engine               = "mysql"
  multi_az             = false  
  instance_class       = "db.t2.micro"
  name                 = "my_rdb"
  publicly_accessible  = false
  availability_zone = "us-east-1a"
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.id
  vpc_security_group_ids = ["${aws_security_group.tf-rds-sg.id}"]
  skip_final_snapshot  = true
  tags = {
    Name = "TF-RDS"
  }
}

#Displaying Outputs
output "Instance_Id" {
  value = aws_instance.TF.id
}
output "Public_IP" {
  value = aws_instance.TF.public_ip
}
output "Private_IP" {
  value = aws_instance.TF.private_ip
}
output "RDS_Endpoint" {
  value = aws_db_instance.TF-RDS.endpoint
}
output "RDS_Username" {
  value = aws_db_instance.TF-RDS.username
}
