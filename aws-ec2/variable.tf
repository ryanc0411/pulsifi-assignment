# variable "aws_cloud_creds" {
#   sensitive   = true
#   description = "AWS Cloud credentials."
#   type = object({
#     access_key = string
#     secret_key = string
#     })
# }

# variable "env" {
#   description = "Enviornment."
#   type        = string
# }

# variable "ec2_configuration" {
#   type = list(object({
#     application_name = string
#     ami = string
#     no_of_instances = number
#     instance_type = string
#   }))
# }