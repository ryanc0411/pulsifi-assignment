variable "aws_cloud_creds" {
  sensitive   = true
  description = "AWS Cloud credentials."
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "region" {
  description = "Region of aws."
  type        = string
}

variable "env" {
  description = "Enviornment."
  type        = string
}

variable "ec2_configuration" {
  type = object({
    application_name = string
    ami              = optional(string, "")
    no_of_instances  = number
    instance_type    = string
  })
}

variable "s3" {
  description = <<EOF
Map of S3's info details.
  - `bucket_name`     : The name of the S3 bucket.
  - `versioning`      : Enable versioning for the S3 bucket.
  - `tags`            : A map of tags to assign to the bucket.
  - `policy`          : JSON bucket policy.
  - `sse_algorithm`   : Server-side encryption algorithm (e.g., AES256).
  - `zone_code`       : Zone code in shorttened form. (e.g. a, b, c)
  - `suffix`          : Resource name suffix.
EOF
  type = object({
    bucket_name   = string
    versioning    = bool
    tags          = map(string)
    policy        = string
    sse_algorithm = string
  })
}

