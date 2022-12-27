### SECURITY GROUPS


# Windwos instance security group

resource "aws_security_group" "winec2_sg" {
  name        = "${var.name_prefix}-winec2_sg"
  description = "Allow RDP access to the instance from any ip"
  vpc_id      = var.vpc_id

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
    Name = "${var.name_prefix}-winec2_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Ubuntu instance security group

resource "aws_security_group" "ubuntu_sg" {
  name        = "${var.name_prefix}-ubuntu_sg"
  description = "Allow SSH, HTTP, 8080 access from ${var.name_prefix}-windwos-server"
  vpc_id      = var.vpc_id

  # SSH access from Windows Ec2
  ingress {
    description     = "Allow SSH from ${var.name_prefix}-windwos-server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.winec2_sg.id]
  }

  # HTTP access from Windows Ec2
  ingress {
    description     = "Allow HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.winec2_sg.id]
  }

  # Port 8080 access from Windows Ec2
  ingress {
    description     = "Allow Guacamole access at 8080"
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
    Name = "${var.name_prefix}-ubuntu_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

