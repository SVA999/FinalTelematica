terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "4.61.0"
}
}

required_version = ">= 1.4.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.allow_http.name]

  provisioner "file" {
    source      = "./install.sh"
    destination = "/home/ubuntu/install.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu" 
      private_key = file(".\\id_rsa")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x "/home/ubuntu/install.sh"",
      ""/home/ubuntu/install.sh""
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu" 
      private_key = file(".\\id_rsa") 
      host        = self.public_ip
    }
  }

  tags = {
    Name = "SnakeGAME"
    Origin = "Terraform"
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "id_rsa"
  public_key = file(".\\id_rsa.pub")
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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