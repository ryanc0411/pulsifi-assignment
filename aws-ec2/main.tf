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
  instance_type = var.ec2_configuration.instance_type                                                           # Instance type (t2.micro is free tier eligible)

  key_name        = aws_key_pair.admin.key_name
  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_nodejs_api_call.name]

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
    Name        = "${var.ec2_configuration.application_name}-${var.env}-${tostring(count.index)}"
    Environment = var.env
  }
}

resource "aws_s3_bucket" "assest" {
  bucket = "${var.s3.bucket_name}-${var.env}"

  tags = merge(var.s3.tags, { "Environment" = var.env })
}

resource "aws_s3_bucket_versioning" "assest_versioning" {

  bucket = aws_s3_bucket.assest.id
  versioning_configuration {
    status = var.s3.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "assest" {
  bucket = aws_s3_bucket.assest.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Optional: Configure bucket policy
resource "aws_s3_bucket_policy" "assest" {
  bucket     = aws_s3_bucket.assest.id
  policy     = var.s3.policy
  depends_on = [aws_s3_bucket.assest, aws_s3_bucket_public_access_block.assest]
}

# Optional: Configure bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "assest" {
  bucket = aws_s3_bucket.assest.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.s3.sse_algorithm
    }
  }
}

resource "aws_kms_key" "s3_object_kms" {
  description             = "s3 Assest KMS Key"
  deletion_window_in_days = 7 # default 30 days.
  enable_key_rotation     = true
}

resource "aws_s3_object" "hello_world" {
  key          = "helloworld"
  bucket       = aws_s3_bucket.assest.id
  source       = "../../image/helloworld.jpg"
  kms_key_id   = aws_kms_key.s3_object_kms.arn
  content_type = "image/jpeg"
}
