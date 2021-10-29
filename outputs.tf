output "zone" {
  description = "Objects describing the zone with: name, arn, zone_id and name servers"
  value = {
    name         = var.zone_name
    arn          = aws_route53_zone.this.arn
    zone_id      = aws_route53_zone.this.zone_id
    name_servers = aws_route53_zone.this.name_servers
  }
}

output "certificate_arn" {
  description = "Objects describing the certificate with: arn and domain_name"
  value = {
    arn         = aws_acm_certificate.this[0].arn
    domain_name = aws_acm_certificate.this[0].domain_name
  }
}
