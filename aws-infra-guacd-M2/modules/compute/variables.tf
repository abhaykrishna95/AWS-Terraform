#Instance Related Variables

variable "vpc_id" {}
variable "name_prefix" {}
variable "pub_subnet_id" {}
variable "pvt_subnet_id" {}
variable "EC2_ROOT_VOLUME_DELETE_ON_TERMINATION" {
  type    = bool
  default = "true"
}
variable "aws_keypair_name" {}

variable "WinEc2InstanceType" {
  type    = string
  default = "t2.micro"
}
variable "Win_EBS_SIZE" {
  type        = string
  description = "The volume size for the windows root volume in GiB"
  default     = "30"
}
variable "Win_EBS_TYPE" {
  type        = string
  description = "The type of data storage: standard, gp2, io1"
  default     = "gp2"
}

variable "UbuntuInstanceType" {
  type    = string
  default = "t2.micro"
}
variable "Ubuntu_EBS_SIZE" {
  type        = string
  description = "The volume size for the ubuntu root volume in GiB"
  default     = "8"
}
variable "Ubuntu_EBS_TYPE" {
  type        = string
  description = "The type of data storage: standard, gp2, io1"
  default     = "gp2"
}
variable "user_data" {}




