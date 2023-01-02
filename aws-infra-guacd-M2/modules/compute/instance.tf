##################################################################################
# DATA
##################################################################################

data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_key_pair" "keypair" {
  key_name           = var.aws_keypair_name
  include_public_key = true

  filter {
    name   = "key-name"
    values = ["${var.aws_keypair_name}"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #



# INSTANCES #

# Create a windows(bastion) and linux(guacamole) instance
resource "aws_instance" "windows_server" {
  ami                    = data.aws_ami.windows_2019.id
  instance_type          = var.WinEc2InstanceType
  vpc_security_group_ids = [aws_security_group.winec2_sg.id]
  subnet_id              = var.pub_subnets[1] #public_subnet2_id
  key_name               = data.aws_key_pair.keypair.key_name

  # root disk
  root_block_device {
    volume_size           = var.Win_EBS_SIZE
    volume_type           = var.Win_EBS_TYPE
    encrypted             = false
    delete_on_termination = var.EC2_ROOT_VOLUME_DELETE_ON_TERMINATION
  }

  tags = {
    terraform = "true"
    Name      = "${var.name_prefix}-bastion-server"
  }
}

resource "aws_instance" "guacd_server" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.GuacInstanceType
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  subnet_id              = var.pvt_subnets[0] #private_subnet1_id
  key_name               = data.aws_key_pair.keypair.key_name
  user_data              = file("deploy_guacd.sh")

  #Note: For above "user_data" key we have used file() function which reads the contents of a given path and returns them as a string.
  # Format :  file("${path.module}/hello.txt")


  # root disk
  root_block_device {
    volume_size           = var.Ubuntu_EBS_SIZE
    volume_type           = var.Ubuntu_EBS_TYPE
    encrypted             = false
    delete_on_termination = var.EC2_ROOT_VOLUME_DELETE_ON_TERMINATION
  }

  tags = {
    terraform = "true"
    Name      = "${var.name_prefix}-guacd-server"
  }
}