# CLOUD_PROVIDER TYPE Terraform module

Terraform module which creates **Rout53 zones** and **ACM Certificates** resources on **AWS**. This module is an abstraction.

## User Stories for this module

- AAOps I can create a new Route53 zone
- AAOps I can add record to the zone
- AAOps I can add delegation record to the zone
- AAOps I can create a certificate for the zone
- ...

## Usage

```hcl
module "example" {
  source = "https://github.com/padok-team/terraform-aws-zoute53-zone"

  zone_name = "exemple.com"

  certificate = {
    enabled = true

    domain_name = "*."
    subject_alternative_names = []
  }
}
```

## Examples

- [Example with one zone and certificate with 2 sans](examples/example_app_front/main.tf)
- [Example with one zone and a wildcard certificate](examples/example_wildcard/main.tf)
- [Example with 1 root zone and 2 sub zones](examples/example_multi_zones/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Certificate to be created for the zone. Domain and sans should end with a "." and exclude the zone name | <pre>object({<br>    enabled                   = bool<br>    domain_name               = string<br>    subject_alternative_names = list(string)<br>  })</pre> | `null` | no |
| <a name="input_records"></a> [records](#input\_records) | Records to be created with the zone. Note that the input is conform with AWS records export from Route53 | <pre>map(object({<br>      Name = string<br>      Type = string<br>      TTL  = optional(number)<br><br>      ResourceRecords = optional(list(object({<br>          Value = string<br>      })))<br><br>      AliasTarget = optional(object({<br>          HostedZoneId         = string<br>          DNSName              = string<br>          EvaluateTargetHealth = bool<br>      }))<br>  }))</pre> | `[]` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | DNS name of the zone (e.g. exemple.com) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | Objects describing the certificate with: arn and domain\_name |
| <a name="output_zone"></a> [zone](#output\_zone) | Objects describing the zone with: name, arn, zone\_id and name servers |
<!-- END_TF_DOCS -->
