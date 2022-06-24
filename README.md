# AWS Route53 Zone and ACM Terraform module

Terraform module which creates **Route53 public zones** resources on **AWS**.

## User Stories for this module

- AAOps I can create a new Route53 zone
- AAOps I can add a delegation record to a zone

## Usage

```hcl
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Env         = local.env
      Region      = local.region
      OwnedBy     = "Padok"
      ManagedByTF = true
    }
  }
}

# some variables to make life easier
locals {
  env    = "test"
  region = "eu-west-3"
}

# Root domain
module "my_zone" {
  source = "../.."

  name = "my_zone.libtime.forge-demo.fr"
}
```

## Examples

- [Example with a simple zone](examples/simple_zone/main.tf)
- [Example with a root zone and 2 childs zone](examples/multi_zone/main.tf)

<!-- BEGIN_TF_DOCS -->

## Modules

No modules.

## Inputs

| Name                                                                                    | Description                                                          | Type     | Default | Required |
| --------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_declare_ns_records"></a> [declare_ns_records](#input_declare_ns_records) | Whether to declare NS records for the created zone                   | `bool`   | `false` |    no    |
| <a name="input_name"></a> [name](#input_name)                                           | DNS name of the zone (e.g. exemple.com).                             | `string` | `null`  |    no    |
| <a name="input_root_zone_id"></a> [root_zone_id](#input_root_zone_id)                   | Route53 zone ID of root domain to add NS record for the created zone | `string` | `null`  |    no    |

## Outputs

| Name                                            | Description                                                           |
| ----------------------------------------------- | --------------------------------------------------------------------- |
| <a name="output_this"></a> [this](#output_this) | Objects describing the zone with: name, arn, zone_id and name servers |

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
