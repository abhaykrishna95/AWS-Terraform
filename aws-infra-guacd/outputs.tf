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

output "windows_server_public_ip" {
  description = "Public IP of the Windows Instance"
  value       = aws_instance.windows_server.public_ip
}

output "guacd_server_private_ip" {
  description = "Private IP of the Ubuntu Instance"
  value       = aws_instance.guacd_server.private_ip
}

output "alb_dns_name" {
  description = "guacamole can be accessed using alb dns name through internet"
  value       = "http://${aws_alb.alb.dns_name}"
}

output "ubuntu_ssh_connection_string" {
  description = "Connection string to SSH to ubuntu instance from windows instance"
  value       = "ssh -i ${var.aws_ec2_keypair_name}.pem ubuntu@${aws_instance.guacd_server.private_ip}"
}

/*

output "guac_portal_url" {
  description = "HTTPS url of the guacamole rdp client"
  value       = "https://${var.guacamole_portal_url}/"
}

*/