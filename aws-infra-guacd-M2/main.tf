##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "networking" {
  source           = "./modules/networking"
  name_prefix      = local.name_prefix
  vpc_cidr_nw_ip   = "10.10" #Example: If vpc_cidr = "10.10.0.0/16" in this the first 2 octate of CIDR IP "10.10" 
  public_sn_count  = 2
  private_sn_count = 2
}

module "compute" {
  source           = "./modules/compute"
  vpc_id           = module.networking.vpc_id
  aws_keypair_name = var.aws_keypair_name
  name_prefix      = local.name_prefix
  pub_subnet_id    = module.networking.public_subnets_id
  pvt_subnet_id    = module.networking.private_subnets_id

  WinEc2InstanceType = var.WinEc2InstanceType
  Win_EBS_SIZE       = var.Windows_EBS_ROOT_VOLUME_SIZE
  Win_EBS_TYPE       = var.Windows_EBS_ROOT_VOLUME_TYPE

  UbuntuInstanceType = var.UbuntuInstanceType
  Ubuntu_EBS_SIZE    = var.Ubuntu_EBS_ROOT_VOLUME_SIZE
  Ubuntu_EBS_TYPE    = var.Ubuntu_EBS_ROOT_VOLUME_TYPE
  user_data          = file("deploy_guacd.sh")
}

module "loadbalancing" {
  source           = "./modules/loadbalancing"
  vpc_id           = module.networking.vpc_id
  pub_subnets      = module.networking.public_subnets_id
  winec2_sg_id     = module.compute.winec2_sg_id
  ubuntu_sg_id     = module.compute.ubuntu_sg_id
  ubuntu_server_id = module.compute.ubuntu_server_id
  name_prefix      = local.name_prefix
}