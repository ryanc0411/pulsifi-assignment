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

# Create a security group that allows node.js api call
resource "aws_security_group" "allow_nodejs_api_call" {
  name        = "allow_nodejs_api_call"
  description = "Allow Nodejs Api Call inbound traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
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
  count = var.ec2_configuration.no_of_instances

  ami           = var.ec2_configuration.ami == "" ? data.aws_ami.amazon_linux_23.id : var.ec2_configuration.ami # Amazon Linux 2023 AMI ID
  instance_type = var.ec2_configuration.instance_type    # Instance type (t2.micro is free tier eligible)

  key_name        = aws_key_pair.admin.key_name
  security_groups = [aws_security_group.allow_ssh.name,aws_security_group.allow_nodejs_api_call.name]

  user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y docker
service docker start
systemctl enable docker
usermod -a -G docker ec2-user
chkconfig docker on
EOF

  tags = {
    Name = "${var.ec2_configuration.application_name}-${tostring(count.index)}"
    Environment = var.env
  }
}
