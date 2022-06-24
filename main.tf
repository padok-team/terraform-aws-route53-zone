# create the zone
resource "aws_route53_zone" "this" {
  name = var.name
}

# if root provided, set NS records to the root zone
resource "aws_route53_record" "delegation" {
  count = var.declare_ns_records ? 1 : 0

  zone_id = var.root_zone_id
  name    = var.name

  type = "NS"
  ttl  = "300"

  records = aws_route53_zone.this.name_servers
}
