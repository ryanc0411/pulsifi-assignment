variable "aws_cloud_creds" {
  sensitive   = true
  description = "AWS Cloud credentials."
  type = object({
    access_key = string
    secret_key = string
    })
}

variable "env" {
  description = "Enviornment."
  type        = string
}

variable "ec2_configuration" {
  type = object({
    application_name = string
    ami = optional(string, "")
    no_of_instances = number
    instance_type = string
  })
}