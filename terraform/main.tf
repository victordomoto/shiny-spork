terraform {
  required_version = "1.9.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}

resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "var.vpc_id" 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "var.cidr_blocks"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_instance" "web_server" {
  ami           = "ami-04a81a99f5ec58529"  
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_server_sg.name]

  tags = {
    Name = "WebServerInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Infra Challenge 20240202</h1>" > /var/www/html/index.html
              EOF
}