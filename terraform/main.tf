provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

# 1. Security Group (Port 80 aur 22 open karne ke liye)
resource "aws_security_group" "doctor_ai_sg" {
  name        = "doctor_ai_sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Django Port"
    from_port   = 8000
    to_port     = 8000
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

# 2. EC2 Instance
resource "aws_instance" "doctor_ai_server" {
  ami           = "ami-03f4878755434977f" # Mumbai Ubuntu 22.04 AMI
  instance_type = "t3.micro"
  key_name      = "terraform-key" # Jo apne AWS Console par banaya hai

  vpc_security_group_ids = [aws_security_group.doctor_ai_sg.id]

  tags = {
    Name = "Doctor-AI-Server"
  }
}

output "instance_ip" {
  value = aws_instance.doctor_ai_server.public_ip
}