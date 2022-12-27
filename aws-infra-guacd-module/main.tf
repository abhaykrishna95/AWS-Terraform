##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "networking" {
  source                  = "./modules/networking"
  name_prefix             = local.name_prefix
  vpc_cidr_block          = var.vpc_cidr_block
  vpc_subnets_cidr_blocks = var.vpc_subnets_cidr_blocks
}

module "compute" {
  source                                = "./modules/compute"
  vpc_id                                = module.networking.vpc_id
  aws_keypair_name                      = var.aws_keypair_name
  EC2_ROOT_VOLUME_DELETE_ON_TERMINATION = var.EC2_ROOT_VOLUME_DELETE_ON_TERMINATION
  name_prefix                           = local.name_prefix
  pub_subnets                           = [module.networking.public_subnet1_id, module.networking.public_subnet2_id]
  pvt_subnets                           = [module.networking.private_subnet1_id, module.networking.private_subnet2_id]

  WinEc2InstanceType = var.WinEc2InstanceType
  Win_EBS_SIZE       = var.Windows_EBS_ROOT_VOLUME_SIZE
  Win_EBS_TYPE       = var.Windows_EBS_ROOT_VOLUME_TYPE

  GuacInstanceType = var.GuacInstanceType
  Ubuntu_EBS_SIZE  = var.Ubuntu_EBS_ROOT_VOLUME_SIZE
  Ubuntu_EBS_TYPE  = var.Ubuntu_EBS_ROOT_VOLUME_TYPE
}

module "loadbalancing" {
  source          = "./modules/loadbalancing"
  vpc_id          = module.networking.vpc_id
  pub_subnets     = [module.networking.public_subnet1_id, module.networking.public_subnet2_id]
  winec2_sg_id    = module.compute.winec2_sg_id
  ubuntu_sg_id    = module.compute.ubuntu_sg_id
  guacd_server_id = module.compute.guacd_server_id
  name_prefix     = local.name_prefix
}