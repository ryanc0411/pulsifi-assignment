# Output the public IP address of the EC2 instance
output "instance_public_ips" {
  value = aws_instance.ec2.*.public_ip
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.assest.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.assest.arn
}