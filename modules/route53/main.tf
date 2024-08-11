resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Route53 resources to perform DNS auto validation
resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z03524862ANL9G4ZXP94J"
}

resource "aws_route53_record" "dns_record" {

  allow_overwrite = true
  name            = var.domain_name
  records         = [var.alb_dns_name]
  ttl             = 60
  type            = "CNAME"
  zone_id         = "Z03524862ANL9G4ZXP94J"
}


resource "aws_acm_certificate_validation" "dns_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]
}