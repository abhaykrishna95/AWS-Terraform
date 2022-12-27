### PUBLIC SUBNETS AND ASSOCIATED ROUTE TABLES

#Create 2 Public Subnets.
resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.vpc_subnets_cidr_blocks[0]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-pub-sub1"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.vpc_subnets_cidr_blocks[1]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name_prefix}-pub-sub2"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#Route table for Public Subnets

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rtb"
  }
  lifecycle {
    create_before_destroy = true
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


### EIP AND NAT GATEWAY

resource "aws_eip" "natEIP" {
  vpc = true
  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }
}

#Creating the NAT Gateway using subnet_id and allocation_id

resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.natEIP.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }
}