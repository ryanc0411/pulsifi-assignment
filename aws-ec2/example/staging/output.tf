output "instance_public_ips" {
  value = module.aws-ec2.instance_public_ips
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.aws-ec2.bucket_name
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.aws-ec2.bucket_arn
}
