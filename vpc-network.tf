##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

#Create the VPC
resource "aws_vpc" "vpc" {
  
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    terraform = "true"
    Name      = "${local.name_prefix}-vpc"
  }
}

#Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    terraform = "true"
    Name      = "${local.name_prefix}-igw"
  }
}

#Create 2 Public Subnets.
resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.vpc_subnets_cidr_blocks[0]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${local.name_prefix}-pub-sub1"
  }
}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.vpc_subnets_cidr_blocks[1]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${local.name_prefix}-pub-sub2"
  }
}

#Create 2 Private Subnets.
resource "aws_subnet" "private_subnet1" {
  cidr_block              = var.vpc_subnets_cidr_blocks[2]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${local.name_prefix}-pvt-sub1"
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block              = var.vpc_subnets_cidr_blocks[3]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${local.name_prefix}-pvt-sub2"
  }
}

resource "aws_eip" "natEIP" {
  vpc = true
  tags = {
    Name = "${local.name_prefix}-nat-gw"
  }
}

#Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.natEIP.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "${local.name_prefix}-nat-gw"
  }
}

# ROUTING #

#Route table for Public Subnets
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}-public-rtb"
  }
}

#Route table for Private Subnets
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "${local.name_prefix}-private-rtb"
  }
}

#Route table Association with Public Subnets
resource "aws_route_table_association" "rta-public-subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "rta-public-subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rtb.id
}

#Route table Association with Private Subnets
resource "aws_route_table_association" "rta-private-subnet1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "rta-private-subnet2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rtb.id
}
