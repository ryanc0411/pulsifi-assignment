module "aws-ec2" {
  source = "../../"
  aws_cloud_creds = {
    access_key = "PLACEHOLDER"
    secret_key = "PLACEHOLDER"
  }

  region = "ap-southeast-1"
  env    = "sandbox"

  ec2_configuration = {
    application_name = "node.js-api-call"
    no_of_instances  = 2
    instance_type    = "t2.micro"
  }

  s3 = {
    bucket_name = "aws-s3-ec2-demo-bucket"
    versioning  = true
    tags = {
      Project = "aws-ec2"
    }
    policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*", 
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::aws-s3-ec2-demo-bucket/*"
    }
  ]
}
EOT
    sse_algorithm = "AES256"
  }

}
