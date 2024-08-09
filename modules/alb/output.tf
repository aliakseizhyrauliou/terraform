output "alb_domain" {
    value = aws_lb.lb.dns_name
}