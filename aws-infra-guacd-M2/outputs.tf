output "vpc_id" {
  description = "Output the ID for the primary VPC"
  value       = module.networking.vpc_id
}


output "windows_server_public_ip" {
  description = "Public IP of the Windows Instance"
  value       = module.compute.windows_server_pub_ip
}

output "ubuntu_server_private_ip" {
  description = "Private IP of the Ubuntu Instance"
  value       = module.compute.ubuntu_server_pvt_ip
}


output "alb_dns_name" {
  description = "guacamole can be accessed using alb dns name through internet"
  value       = "http://${module.loadbalancing.alb_dns_name}"
}

output "ubuntu_ssh_connection_string" {
  description = "Connection string to SSH to ubuntu instance from windows instance"
  value       = "ssh -i ${var.aws_keypair_name}.pem ubuntu@${module.compute.ubuntu_server_pvt_ip}"
}

/*

output "guac_portal_url" {
  description = "HTTPS url of the guacamole rdp client"
  value       = "https://${var.guacamole_portal_url}/"
}

*/