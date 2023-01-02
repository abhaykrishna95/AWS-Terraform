### PRIVATE SUBNETS AND ASSOCIATED ROUTE TABLES

#Create 2 Private Subnets.
resource "aws_subnet" "private_subnets" {
  count                   = var.private_sn_count
  cidr_block              = "${var.vpc_cidr_nw_ip}.${80 + count.index}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-pvt-sub${count.index + 1}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# ROUTING #

#Route table for Private Subnets

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name_prefix}-private-rtb"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default_private_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NATgw.id
}

#Route table Association with Private Subnets

resource "aws_route_table_association" "private-rta-assoc" {
  count          = var.private_sn_count
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
}
