variable "environment" {
  type        = string
  description = "Environment name for resource tagging (Ex: Dev, Stage, Prod)"
  default     = "Dev"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "Demo"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_cidr_blocks" {
  type        = list(string)
  description = "CIDR Blocks for Subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

#Instance Related Variables

variable "GuacInstanceType" {
  type        = string
  description = "Provide the instance type for ubuntu ec2 instance"
  default     = "t2.micro"
}

variable "WinEc2InstanceType" {
  type        = string
  description = "Provide the instance type for windows ec2 instance"
  default     = "t2.micro"
}

variable "Windows_EBS_ROOT_VOLUME_SIZE" {
  type        = string
  description = "The volume size for the windows root volume in GiB"
  default     = "30"
}

variable "Windows_EBS_ROOT_VOLUME_TYPE" {
  type        = string
  description = "The type of data storage: standard, gp2, io1"
  default     = "gp2"
}

variable "Ubuntu_EBS_ROOT_VOLUME_SIZE" {
  type        = string
  description = "The volume size for the ubuntu root volume in GiB"
  default     = "8"
}

variable "Ubuntu_EBS_ROOT_VOLUME_TYPE" {
  type        = string
  description = "The type of data storage: standard, gp2, io1"
  default     = "gp2"
}

variable "EC2_ROOT_VOLUME_DELETE_ON_TERMINATION" {
  type        = bool
  description = "Delete the root volume on instance termination."
  default     = true
}

variable "aws_ec2_keypair_name" {
  type        = string
  description = "name of the aws key pair required to access new instances"
}

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