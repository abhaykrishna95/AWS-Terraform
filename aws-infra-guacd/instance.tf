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

data "aws_key_pair" "abhay62_keypair" {
  key_name           = var.aws_ec2_keypair_name
  include_public_key = true

  filter {
    name   = "key-name"
    values = ["${var.aws_ec2_keypair_name}"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

# Windwos instance security group 
resource "aws_security_group" "winec2_sg" {
  name        = "${local.name_prefix}-winec2_sg"
  description = "Allow RDP access to the instance from any ip"
  vpc_id      = aws_vpc.vpc.id

  # RDP access from VPC
  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-winec2_sg"
  }
}

resource "aws_security_group" "ubuntu_sg" {
  name        = "${local.name_prefix}-ubuntu_sg"
  description = "Allow SSH, HTTP, 8080 access from ${local.name_prefix}-windwos-server"
  vpc_id      = aws_vpc.vpc.id

  # SSH access from Windows Ec2
  ingress {
    description = "Allow SSH from ${local.name_prefix}-windwos-server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.winec2_sg.id]
  }

  # HTTP access from Windows Ec2
  ingress {
    description = "Allow HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.winec2_sg.id]
  }

  # Port 8080 access from Windows Ec2
  ingress {
    description = "Allow Guacamole access at 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.winec2_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-ubuntu_sg"
  }
}

# INSTANCES #

# Create a windows(bastion) and linux(guacamole) instance
resource "aws_instance" "windows_server" {
  ami                    = data.aws_ami.windows_2019.id
  instance_type          = var.WinEc2InstanceType
  vpc_security_group_ids = [aws_security_group.winec2_sg.id]
  subnet_id              = aws_subnet.public_subnet2.id
  key_name               = data.aws_key_pair.abhay62_keypair.key_name

  # root disk
  root_block_device {
    volume_size           = var.Windows_EBS_ROOT_VOLUME_SIZE
    volume_type           = var.Windows_EBS_ROOT_VOLUME_TYPE
    encrypted             = false
    delete_on_termination = var.EC2_ROOT_VOLUME_DELETE_ON_TERMINATION
  }

  tags = {
    terraform = "true"
    Name      = "${local.name_prefix}-bastion-server"
  }
}

resource "aws_instance" "guacd_server" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.GuacInstanceType
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  subnet_id              = aws_subnet.private_subnet1.id
  key_name               = data.aws_key_pair.abhay62_keypair.key_name
  user_data              = file("deploy_guacd.sh")

  #Note: For above "user_data" key we have used file() function which reads the contents of a given path and returns them as a string.
  # Format :  file("${path.module}/hello.txt")


  # root disk
  root_block_device {
    volume_size           = var.Ubuntu_EBS_ROOT_VOLUME_SIZE
    volume_type           = var.Ubuntu_EBS_ROOT_VOLUME_TYPE
    encrypted             = false
    delete_on_termination = var.EC2_ROOT_VOLUME_DELETE_ON_TERMINATION
  }

  tags = {
    terraform = "true"
    Name      = "${local.name_prefix}-guacd-server"
  }
}