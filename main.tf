# Here you can reference 2 type of terraform objects :
# 1. Ressources from you provider of choice
# 2. Modules from official repositories which include modules from the following github organizations
#     - AWS: https://github.com/terraform-aws-modules
#     - GCP: https://github.com/terraform-google-modules
#     - Azure: https://github.com/Azure

# Create
#  - 1 Route53 zone
#  - 1 ACM certificate, with DNS validation, if enabled

# ====================[ Route53 zone ] ======================

resource "aws_route53_zone" "this" {
  name    = var.zone_name
  tags    = var.tags
}

# ====================[ Route53 zone delegation ] ===========

resource "aws_route53_record" "delegation" {
  for_each = var.delegations

  zone_id  = aws_route53_zone.this.zone_id
  name     = each.key

  type = "NS"
  ttl  = "300"

  records = each.value
}

# ====================[ Certificate ] =======================

resource "aws_acm_certificate" "this" {
  count = var.certificate["enabled"] ? 1 : 0

  domain_name               = join(".", [var.certificate["domain_name"], var.zone_name])
  subject_alternative_names = [for sans in var.certificate["subject_alternative_names"]: join(".", [sans, var.zone_name])]

  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Note: dvo = domain validation option
resource "aws_route53_record" "validation" {
  for_each = length(aws_acm_certificate.this) == 0 ? {} : {
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.this.zone_id

  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type

  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "this" {
  count = var.certificate["enabled"] ? 1 : 0

  certificate_arn         = aws_acm_certificate.this[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
