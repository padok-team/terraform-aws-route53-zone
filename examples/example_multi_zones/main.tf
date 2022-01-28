# 3 zones:
#   Parent zone
#   Child zones
#     Staging
#     Prod
#
# Parent zone
#   Doesn't create certificates
#   But create delegations to child zones
#
# Child zones
#   Create a certificate and a clone certficate,
#     each with wildcard and zone apex coverage
#
# Note: Certificate should stay disabled until you have performed zone delegation

provider "aws" {
  profile = ""
  region  = "eu-west-2"
  default_tags {
    tags = {
      Environment = "Organization"
      Layer       = "Organization"
      Owner       = "Padok"
    }
  }
}

provider "aws" {
  alias = "east"
  profile = ""
  region  = "eu-east-1"
  default_tags {
    tags = {
      Environment = "Organization"
      Layer       = "Organization"
      Owner       = "Padok"
    }
  }
}

locals {
  domain = "libtime.forge-demo.fr"
  domains_childs = {
    for env in ["staging", "production"]:
      env => format("%s.%s", "staging", module.zone_root.zone["name"])
    }
}

# Create NS record to catch another zone

module "zone_root" {
  source = "../.."

  zone_name = local.domain

  certificate = {
    enabled = false
  }

  delegations = {
    "staging" = module.zone_staging.zone.name_servers
    "preprod" = module.zone_preprod.zone.name_servers
  }
}

module "zone_staging" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.east
  }

  zone_name = local.domains_childs["staging"]

  certificate = {
    enabled       = true
    enabled_clone = true

    domain_name = ""
    subject_alternative_names = ["*."]
  }
}

module "zone_production" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.east
  }

  zone_name = local.domains_childs["production"]

  certificate = {
    enabled       = true
    enabled_clone = true

    domain_name = ""
    subject_alternative_names = ["*."]
  }
}


# module "zone_root" {}

# module "zone_staging" {
#   depends_on = [module.zone_root]
# }
# module "zone_delegate_root_staging" {
#   depends_on = [module.zone_staging]
# }
# module "certificate_staging" {
#   depends_on = [module.zone_delegate_root_staging]
# }


# module "zone_production" {
#   depends_on = [module.zone_root]
# }
# module "zone_delegate_root_production" {
#   depends_on = [module.zone_production]
# }
# module "certificate_production" {
#   depends_on = [module.zone_delegate_root_production]
# }
