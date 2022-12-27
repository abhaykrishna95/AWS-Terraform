variable "vpc_id" {}
variable "winec2_sg_id" {}
variable "ubuntu_sg_id" {}
variable "guacd_server_id" {}
variable "pub_subnets" {}
variable "name_prefix" {}


/*

variable "sslcert_arn_for_alb" {
  type        = string
  description = "Provide the ARN of the existing SSL Certificate to be used for ALB"
}

variable "R53_HostedZoneId" {
  type        = string
  description = "Provide the Route 53 Hosted Zone ID to create a CNAME record"
}

variable "guacamole_portal_url" {
  type        = string
  description = "Mention the desired guacamole portal URL"
}

*/