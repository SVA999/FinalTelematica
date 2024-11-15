provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "id_rsa"
  public_key = file("./id_rsa.pub")
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
    cidr_blocks = ["0.0.0.0/0"]  # Puedes restringirlo a tu IP pública por seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-005fc0f236362e99f"  # Verifica que la AMI sea válida en us-west-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              chmod +x /tmp/install.sh
              /tmp/install.sh
              EOF

  tags = {
    Name = "GAME-Snake"
  }
}

resource "null_resource" "provision" {
  depends_on = [aws_instance.my_instance]

  provisioner "file" {
    source      = "./docker-compose.yml"
    destination = "/tmp/docker-compose.yml"
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Ajusta el usuario según la AMI
      private_key = file("./id_rsa")
      host        = aws_instance.my_instance.public_ip
    }
  }

provisioner "remote-exec" {
    inline = [   
      "chmod +x /tmp/docker-compose.yml",
      "/tmp/docker-compose.yml"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Ajusta el usuario según la AMI
      private_key = file("./id_rsa")
      host        = aws_instance.my_instance.public_ip
    }
  }
}