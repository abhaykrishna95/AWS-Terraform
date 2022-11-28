# Terraform Project

TF-Task1 project:

Script devided into 6 TF files to ease the maintenance
  1) variables.tf :  User defined (default) values can be passed here 
  2) terraform.tfvars : User can override the default values pre-defined in varibales.tf
  3) locals.tf : We can mention commin tags or name_prefix for naming resources
  4) vpc-network.tf : Includes Networking part in deployment 
      a) 1 each - VPC, IGW, EIP, NAT GW, Pub RT, Pvt RT
      b) 2 each - Pub Sub, Pvt Sub, Pub Sub-RTA, Pvt Sub-RTA
  5) instance.tf : Includes 2 ec2 instance deployment
      a) Windows SG - RDP open to public network
      b) Ubuntu SG - Ports 22, 80, 8080 open only to above Windows SG
      c) Windwos Server 2019 instance - hosted in public subnet. Acts as a bastion vm to access ubuntu instance for administration.
      d) Ubuntu 22.04 instance - hosted in private subnet
         i) Includes a key > user_data = file("deploy_guacd.sh") which reads the local bash script and executes it once vm is running.
         ii) Bash file installs docker, docker compose, then deploy mysql, guacd and guacamole containers in vm.
  6) aws-alb.tf : Includes Application Load Balancer deployment and attach it to ubuntu instance
      a) ALB SG -  Allows http protocol from any ipv4 address or public network
      b) Add a new ingress rule in Ubuntu-SG for port 8080 access from alb-sg
      c) TG - Instance type TG, port 8080, attach to target -> ubuntu instance at port 8080 (alb_tg_attachment)
      d) ALB - HTTP port 80  (We can use HTTPS at port 443, uncomment ssl_policy and cert arn lines in the script) 
      e) ALB listener - listenes HTTPS traffic on port 80, default action -> forward traffic to Target Group (TG) with ubuntu instance port 8080.
      f) Route 53 record (Uncomment to enable) - create a CNAME record pointing to ALB DNS name.
      
 This deployment hosts guacamole server in ubuntu instance and makes it publically accesible through ALB DNS endpoint(for HTTP) mapped in R53 record (for HTTPS)
 
 Note: To use HTTPS configured URL - specify the sslcert_arn_for_alb, R53_HostedZoneId and guacamole_portal_url in terraform.tfvars file.
  

