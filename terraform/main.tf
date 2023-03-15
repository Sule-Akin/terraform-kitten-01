terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
resource "aws_security_group" "secgrp" {
  name        = "kittens_ssh_http"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }
   ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "kittens01" {
  ami           = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  key_name = "xxxxxx-key"
  vpc_security_group_ids = [ aws_security_group.secgrp.id ]
  tags = {
    Name = "kitten-01"
  }
  user_data = "${file("userdata.sh")}"
}

output "kittenspublicip" {
    value = aws_instance.kittens01.public_ip
  
}