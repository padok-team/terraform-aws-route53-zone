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
#   each with wildcard and zone apex coverage
#
# Note: Certificate should stay disabled until you have performed zone delegation

# These example will use your local credentials in Paris region
provider "aws" {
  region = "eu-west-3"
}
provider "aws" {
  alias  = "clone"
  region = "us-east-1"
}

# Setup a root domain and a child domain
locals {
  domain_root = "libtime.XXX.fr"
  domains = {
    for env in ["zone-staging", "zone-preproduction", "zone-production"] :
    env => format("%s.%s", env, module.zone_root.zone["name"])
  }
}

# Create a certificate for the root zone:
#  - Will not change anything in the root zone config
#    because it does not belong to this Terraform context,
#    but it can add NS records to the zone to perform zone delegation
module "zone_root" {
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
    "zone-staging"       = module.zone_staging.zone.name_servers
    "zone-preproduction" = module.zone_preproduction.zone.name_servers
    "zone-production"    = module.zone_production.zone.name_servers
  }
}

# Create a zone:
#  - With delegation from the root zone above
#  - With certificate with wildcard and zone apex SANs
#  - Without cloned certificate
module "zone_staging" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.clone
  }

  zone = {
    create = true
    name   = local.domains["zone-staging"]
  }

  certificate = {
    enabled       = true
    enabled_clone = false

    domain_name               = ""
    subject_alternative_names = ["*."]
  }
}

# Create a zone:
#  - With delegation from the root zone above
#  - With certificate with wildcard and zone apex SANs
#  - Without cloned certificate
module "zone_preproduction" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.clone
  }

  zone = {
    create = true
    name   = local.domains["zone-preproduction"]
  }

  certificate = {
    enabled       = true
    enabled_clone = false

    domain_name               = ""
    subject_alternative_names = ["*."]
  }
}

# Create a zone:
#  - With delegation from the root zone above
#  - With certificate with wildcard + zone apex SANs
#  - With a cloned certificate in us-east-1
module "zone_production" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.clone
  }

  zone = {
    create = true
    name   = local.domains["zone-production"]
  }

  certificate = {
    enabled       = true
    enabled_clone = true

    domain_name               = ""
    subject_alternative_names = ["*."]
  }
}
