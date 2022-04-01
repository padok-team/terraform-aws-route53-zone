output "zone" {
  description = "Objects describing the zone with: name, arn, zone_id and name servers"
  value = {
    name         = local.zone_internal.name
    arn          = local.zone_internal.arn
    zone_id      = local.zone_internal.zone_id
    name_servers = local.zone_internal.name_servers
  }
}

output "certificate" {
  description = "Objects describing the certificate with: arn and domain_name"
  value       = length(module.certificate) != 0 ? module.certificate[0].certificate : null
}

output "certificate_clone" {
  description = "Objects describing the clone certificate with: arn and domain_name"
  value       = length(module.certificate_clone) != 0 ? module.certificate_clone[0].certificate : null
}
