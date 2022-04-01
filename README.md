# AWS Route53 Zone and ACM Terraform module

Terraform module which creates **Route53 public zones** and **ACM Certificates** resources on **AWS**.

## User Stories for this module

- AAOps I can create a new Route53 zone
- AAOps I can add a delegation record to a zone
- AAOps I can create a certificate for a zone
- AAOps I can create a cloned certificate in another region

## Usage

```hcl
# 2 zones:
#  - 1 is managed outside of Terraform, and will just get
#    - NS records for delegation to the child zone
#    - A certificate
#
#  - The other one it managed by Terraform:
#    - Therefore created by it
#    - And will get a wildcard certificate
#
# Note: Certificates for the child zones will stay disabled until you have performed zone delegation

# This example will use your local credentials in Paris region
provider "aws" {
  region = "eu-west-3"
}

# Setup a root domain and a child domain
locals {
  domain_root = "libtime.XXX.fr"
  domain      = format("zone-app.%s", local.domain_root)
}

# Create a certificate for the root zone
#  - Will not change anything in the root zone config
#    because it does not belong to this Terraform context,
#    but it can add NS records to the zone to perform zone delegation
module "zone_libtime" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws
  }

  zone = {
    create = false
    name   = local.domain_root
  }

  certificate = {
    enabled = false

    domain_name = ""
  }

  delegations = {
    "zone-app" = module.zone_app.zone.name_servers
  }
}

# Create a zone
#  - With delegation from the root zone above
#  - With a wildcard certificate
#  - With no cloned certificate in other regions
module "zone_app" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws
  }

  zone = {
    create = true
    name   = local.domain
  }

  certificate = {
    enabled = true

    domain_name               = "*."
    subject_alternative_names = []
  }
}

# Test record: to check that your zone delegation from the parent zone is working
resource "aws_route53_record" "test" {
  zone_id = module.zone_app.zone.zone_id
  name    = format("test.%s", module.zone_app.zone.name)
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
}
```

## Schema

![Schema DNS](./img/schema.png)

## Examples

- [Example with a root zone with 1 certificate and a child zone with 2 certificates in differents regions](examples/example_app_front/main.tf)
- [Example with 1 existing root zone and 2 sub zones](examples/example_multi_zones/main.tf)
- [Example with 1 child zone and a wildcard certificate](examples/example_wildcard/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_certificate"></a> [certificate](#module\_certificate) | ./modules/terraform-aws-certificate | n/a |
| <a name="module_certificate_clone"></a> [certificate\_clone](#module\_certificate\_clone) | ./modules/terraform-aws-certificate | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Certificate to be created for the zone. Domain and sans should end with a "." and exclude the zone name. | <pre>object({<br>    enabled                   = optional(bool)<br>    enabled_clone             = optional(bool)<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_delegations"></a> [delegations](#input\_delegations) | Map { <sub\_zone> => [<name\_servers>] in order to setup delegations. For <sub\_zones> just put the sub domain. | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be added to resources in the module that support it | `map(string)` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | DNS name of the zone (e.g. exemple.com). | <pre>object({<br>    create = optional(bool)<br>    name   = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | Objects describing the certificate with: arn and domain\_name |
| <a name="output_certificate_clone"></a> [certificate\_clone](#output\_certificate\_clone) | Objects describing the clone certificate with: arn and domain\_name |
| <a name="output_zone"></a> [zone](#output\_zone) | Objects describing the zone with: name, arn, zone\_id and name servers |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
