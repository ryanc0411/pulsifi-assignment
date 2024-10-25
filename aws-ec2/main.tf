# Create a admin key pair for SSH access to the EC2 instance
resource "aws_key_pair" "admin" {
  key_name   = "admin-key-pair"
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
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux_23.id # Amazon Linux 2023 AMI ID
  instance_type = "t2.micro"              # Instance type (t2.micro is free tier eligible)

  key_name      = aws_key_pair.admin.key_name
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "MyExampleInstance"
  }
}
