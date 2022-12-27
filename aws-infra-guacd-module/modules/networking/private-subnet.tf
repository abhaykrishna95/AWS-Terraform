### PRIVATE SUBNETS AND ASSOCIATED ROUTE TABLES

#Create 2 Private Subnets.
resource "aws_subnet" "private_subnet1" {
  cidr_block              = var.vpc_subnets_cidr_blocks[2]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-pvt-sub1"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private_subnet2" {
  cidr_block              = var.vpc_subnets_cidr_blocks[3]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name_prefix}-pvt-sub2"
  }
  lifecycle {
    create_before_destroy = true
  }
}



# ROUTING #

#Route table for Private Subnets

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "${var.name_prefix}-private-rtb"
  }
  lifecycle {
    create_before_destroy = true
  }
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
