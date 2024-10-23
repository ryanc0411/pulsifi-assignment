# Define the provider - in this case, AWS
provider "aws" {
  region = "us-west-2" # Define the AWS region
}

# Create a key pair for SSH access to the EC2 instance
resource "aws_key_pair" "example" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your public SSH key
}

# Create a security group that allows inbound SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

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

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-07c5ecd8498c59db5" # Amazon Linux 2 AMI ID (change as needed)
  instance_type = "t2.micro"              # Instance type (t2.micro is free tier eligible)

  key_name      = aws_key_pair.example.key_name
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "MyExampleInstance"
  }
}

# Output the public IP address of the EC2 instance
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

