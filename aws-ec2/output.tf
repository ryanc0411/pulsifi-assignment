# Output the public IP address of the EC2 instance
output "instance_public_ips" {
  value = aws_instance.ec2.*.public_ip
}