variable "environment" {
  type        = string
  description = "Environment name for resource tagging (Ex: Dev, Stage, Prod)"
  #default     = "Dev"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  #default     = "Demo"
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

#VPC Related Variables

variable "vpc_cidr_nw_ip" {
  type        = string
  description = "If the desired vpc-cidr-block = 10.10.0.0/16 then the first 2 octet is 10.10"
}


#Instance Related Variables

variable "UbuntuInstanceType" {
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

variable "aws_keypair_name" {
  type        = string
  description = "name of the aws key pair required to access new instances"
}

