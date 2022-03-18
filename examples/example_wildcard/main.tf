# 2 zones:
#  - 1 is managed outside of Terraform, and will just get
#    - NS records for delegation to the child zone
#    - A certificate
#
#  - The other one it managed by Terraform,
#    - Therefore created by it
#    - And will get a wildcard certificate
#
# Note: Certificates for the child zones, will stay disabled until you have performed zone delegation

# This example will use your local credentials + Paris region
provider "aws" {
  region = "eu-west-3"
}

# Setup a root domain + a child domain
locals {
  domain_root = "libtime.forge-demo.fr"
  domain = format("zone-app.%s", local.domain_root)
}

# Create a certificate for the root zone
#  - Will not change anything in the root zone config
#    Because it does not belong to this Terraform context,
#    But it can add NS records to the zone to perform zone delegation
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

    domain_name = "*."
    subject_alternative_names = []
  }
}

# Test record: to check that your zone delegation from parent zone is working
resource "aws_route53_record" "test" {
  zone_id = module.zone_app.zone.zone_id
  name    = format("test.%s", module.zone_app.zone.name)
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
}
