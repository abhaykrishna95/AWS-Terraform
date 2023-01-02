### CUSTOM VPC CONFIGURATION

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc" "vpc" {

  cidr_block           = "${var.vpc_cidr_nw_ip}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    terraform = "true"
    Name      = "${var.name_prefix}-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

### INTERNET GATEWAY

#Create Internet Gateway and attach it to VPC

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    terraform = "true"
    Name      = "${var.name_prefix}-igw"
  }
  lifecycle {
    create_before_destroy = true
  }
}



