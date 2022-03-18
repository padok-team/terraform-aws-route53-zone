# Zone with certificate for classics: exemple.com and www.exemple.com
#
# Note: Certificate should stay disabled until you have performed zone delegation

# These example will use your local credentials + Paris region
provider "aws" {
  region = "eu-west-3"
}
provider "aws" {
  alias  = "clone"
  region = "us-east-1"
}

# Setup a root domain + a child domain
locals {
  domain_root = "libtime.forge-demo.fr"
  domain = format("zone-app-front.%s", local.domain_root)
}

# Create a certificate for the root zone
#  - Will not change anything in the root zone config
#    Because it does not belong to this Terraform context,
#    But it can add NS records to the zone to perform zone delegation
#
#  - Will create a certificate that will be validated
#    using this zone + DNS challenge
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
    enabled = true

    domain_name = ""
  }

  delegations = {
    "zone-app-front" = module.zone_app_front.zone.name_servers
  }
}

# Create a zone
#  - With delegation from the root zone above
#  - With certificate with www. + zone apex SANs
#  - With a cloned certificate in us-east-1 
module "zone_app_front" {
  source = "../.."

  providers = {
    aws       = aws
    aws.clone = aws.clone
  }

  zone = {
    create = true
    name   = local.domain
  }

  certificate = {
    enabled       = true
    enabled_clone = true

    domain_name = "www."
    subject_alternative_names = [
        ""
    ]
  }
}


# Test record: to check that your zone delegation from parent zone is working
resource "aws_route53_record" "test" {
  zone_id = module.zone_app_front.zone.zone_id
  name    = format("test.%s", module.zone_app_front.zone.name)
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
}
