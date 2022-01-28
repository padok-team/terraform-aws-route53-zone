resource "aws_acm_certificate" "this" {
  domain_name               = join("", [var.certificate["domain_name"], var.zone.name])
  subject_alternative_names = [for sans in var.certificate["subject_alternative_names"] : join("", [sans, var.zone.name])]

  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Note: dvo = domain validation option
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.zone.id

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type

  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
