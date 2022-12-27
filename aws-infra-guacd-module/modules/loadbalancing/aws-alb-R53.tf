##################################################################################
# RESOURCES
##################################################################################

#create a security group for Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow http protocol from any ipv4 address"
  vpc_id      = var.vpc_id

  # HTTPS access from internet
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "${var.name_prefix}-alb_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}


#Add a new ingress rule in ubuntu-sg for port 8080 access from alb-sg
resource "aws_security_group_rule" "ubuntu_sg_alb_ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = var.ubuntu_sg_id
}


#Create Target Group (Instance type) for ALB
resource "aws_alb_target_group" "alb_tg" {
  name        = "${var.name_prefix}-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/"
    port                = "traffic-port"
    matcher             = "200"
  }
}

#Attach the target instance to which the ALB should route the traffic
resource "aws_alb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_alb_target_group.alb_tg.arn
  target_id        = var.guacd_server_id
  port             = 8080
}

#Create Application Load Balancer
resource "aws_alb" "alb" {
  name               = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.pub_subnets
  ip_address_type    = "ipv4"
}

#Create ALB listener
resource "aws_alb_listener" "alb_listener_HTTP" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  #  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  #  certificate_arn   = var.sslcert_arn_for_alb

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}

/*
#Create Route53 CNAME record using ALB dns name for guacamole portal url
resource "aws_route53_record" "alb_R53_recordset" {
  zone_id = var.R53_HostedZoneId
  name    = var.guacamole_portal_url
  type    = "CNAME"
  ttl     = 300
  records = [aws_alb.alb.dns_name]
}
*/
