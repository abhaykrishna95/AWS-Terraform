### PUBLIC SUBNETS AND ASSOCIATED ROUTE TABLES

#Create 2 Public Subnets.
resource "aws_subnet" "public_subnets" {
  count                   = var.public_sn_count
  cidr_block              = "${var.vpc_cidr_nw_ip}.${20 + count.index}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-pub-sub${count.index + 1}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

#Route table for Public Subnets

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name_prefix}-public-rtb"
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


#Route table Association with Public Subnets

resource "aws_route_table_association" "public-rta-assoc" {
  count          = var.public_sn_count
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
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
  subnet_id     = aws_subnet.public_subnets[0].id # Index [0] = public_subnet_1

  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }
}