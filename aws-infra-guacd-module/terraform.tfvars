##AWS ACCOUNT
aws_access_key = "AKIA2LS7OF6DDBBBQ5YD"
aws_secret_key = "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"
aws_region     = "us-east-1"

##PROJECT INFO
environment = "Dev"
project     = "rdp"

##NETWORKING
vpc_cidr_block          = "10.10.0.0/18"
vpc_subnets_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]


##COMPUTE
aws_keypair_name                      = "krishna95-Nvirginia-keypair"
EC2_ROOT_VOLUME_DELETE_ON_TERMINATION = "true"

#Ubuntu instance
GuacInstanceType            = "t2.micro"
Ubuntu_EBS_ROOT_VOLUME_SIZE = "8"
Ubuntu_EBS_ROOT_VOLUME_TYPE = "gp2"

#Windows instance
WinEc2InstanceType           = "t2.micro"
Windows_EBS_ROOT_VOLUME_SIZE = "30"
Windows_EBS_ROOT_VOLUME_TYPE = "gp2"


#sslcert_arn_for_alb = "arn:aws:acm:us-east-1:6svsfvsv532259:certificate/09b84635483-15df-4aa5-9111-63673466479gfd5"

#R53_HostedZoneId = "AKKPTPRSDFGES3V"

#guacamole_portal_url = "guacamole.domain.com"
