module "aws-ec2" {
	source = "../../"
  aws_cloud_creds = {
      access_key = 
      secret_key = 
    }

	env = "sandbox"

	ec2_configuration = {
		application_name = "node.js-api-call"
    no_of_instances = 2
    instance_type = "t2.micro"
	}
}