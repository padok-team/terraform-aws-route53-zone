# Create
#  - 1 Route53 zone
#  - 1 ACM certificate, with DNS validation, if enabled


# ====================[ Default Certificate ] ===============

locals {
  certificate = defaults (
    var.certificate,
    {
      enabled       = false
      enabled_clone = false

      domain_name = ""
      # subject_alternative_names = 
  })

  zone_internal = var.zone["create"] ? aws_route53_zone.this[0] : data.aws_route53_zone.this[0]
}

# ====================[ Route53 zone ] ======================

resource "aws_route53_zone" "this" {
  count = var.zone["create"] ? 1 : 0

  name = var.zone["name"]
  tags = var.tags
}

# Use data source only when we do not want to create the zone, but reuse another one
data "aws_route53_zone" "this" {
  count = var.zone["create"] ? 0 : 1

  name         = var.zone["name"]
  private_zone = false
}

# ====================[ Route53 zone delegation ] ===========

resource "aws_route53_record" "delegation" {
  for_each = var.delegations

  zone_id = local.zone_internal.zone_id
  name    = each.key

  type = "NS"
  ttl  = "300"

  records = each.value
}

# ====================[ Certificates ] =======================

module "certificate" {
  count  = local.certificate["enabled"] ? 1 : 0
  source = "./modules/terraform-aws-certificate"

  tags = var.tags

  certificate = local.certificate
  zone        = {
    name = local.zone_internal.name
    id   = local.zone_internal.zone_id
  }
}

# Create a clone using another provider if required
#  => Useful for example for CloudFront that require a certificate in us-east-1
module "certificate_clone" {
  count    = local.certificate["enabled_clone"] ? 1 : 0
  source = "./modules/terraform-aws-certificate"

  tags = var.tags

  providers = {
    aws = aws.clone
  }

  certificate = local.certificate
  zone        = {
    name = local.zone_internal.name
    id   = local.zone_internal.zone_id
  }
}
