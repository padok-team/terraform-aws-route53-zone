# Zone with a wildcard certificate *.exemple.com
#
# Note: Certificate should stay disabled until you have performed zone delegation

provider "aws" {
  region = "eu-west-3"
}

locals {
  domain_root = "libtime.forge-demo.fr"
  domain = format("zone-app.%s", local.domain_root)
}

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
    domain_name = "toto"
  }

  delegations = {
    "zone-app" = module.zone_app.zone.name_servers
  }
}

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

    domain_name = "*."
    subject_alternative_names = []
  }
}
