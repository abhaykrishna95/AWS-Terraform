output "windows_server_pub_ip" {
  description = "Public IP of the Windows Instance"
  value       = aws_instance.windows_server.public_ip
}

output "ubuntu_server_pvt_ip" {
  description = "Private IP of the Ubuntu Instance"
  value       = aws_instance.ubuntu_server.private_ip
}

output "winec2_sg_id" {
  description = "Windows SG ID"
  value       = aws_security_group.winec2_sg.id
}

output "ubuntu_sg_id" {
  description = "Ubuntu SG ID"
  value       = aws_security_group.ubuntu_sg.id
}

output "ubuntu_server_id" {
  description = "ubuntu server instance ID"
  value       = aws_instance.ubuntu_server.id
}
