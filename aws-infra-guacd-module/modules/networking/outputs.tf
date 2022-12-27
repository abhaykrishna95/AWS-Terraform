output "vpc_id" {
  description = "Output the ID for the primary VPC"
  value       = aws_vpc.vpc.id
}

output "igw_id" {
  description = "Output the ID for the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet1_id" {
  description = "Output the ID for the public subnet 1"
  value       = aws_subnet.public_subnet1.id
}

output "public_subnet2_id" {
  description = "Output the ID for the public subnet 2"
  value       = aws_subnet.public_subnet2.id
}

output "private_subnet1_id" {
  description = "Output the ID for the private subnet 1"
  value       = aws_subnet.private_subnet1.id
}

output "private_subnet2_id" {
  description = "Output the ID for the private subnet 2"
  value       = aws_subnet.private_subnet2.id
}

output "nat_gw_id" {
  description = "Output the ID for the private subnet 2"
  value       = aws_nat_gateway.NATgw.id
}

output "EIP" {
  description = "Output the ID for the private subnet 2"
  value       = aws_eip.natEIP.public_ip
}
