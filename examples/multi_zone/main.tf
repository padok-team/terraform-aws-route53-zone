# 3 zones:
#   Parent zone
#   Child zones
#     Staging
#     Prod
#

terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

# our default provider
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
  env         = "test"
  region      = "eu-west-3"
  root_domain = "root_example.libtime.forge-demo.fr"
}

# Root domain
module "root" {
  source = "../.."

  name = local.root_domain
}

# First "child" domain
module "staging" {
  source = "../.."

  name = "staging.${local.root_domain}"

  declare_ns_records = true
  root_zone_id       = module.root.this.zone_id
}

# Second "child" domain
module "preprod" {
  source = "../.."

  name = "preprod.${local.root_domain}"

  declare_ns_records = true
  root_zone_id       = module.root.this.zone_id
}
