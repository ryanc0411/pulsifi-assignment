variable "aws_cloud_creds" {
  sensitive   = true
  description = "AWS Cloud credentials."
  type = object({
    access_key = string
    secret_key = string
    })
}

