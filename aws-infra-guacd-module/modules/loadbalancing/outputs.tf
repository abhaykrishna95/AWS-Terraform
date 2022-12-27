output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = aws_alb.alb.dns_name
}

