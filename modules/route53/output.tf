output "cert" {
  value = aws_acm_certificate_validation.example.certificate_arn
}