# Zone with a wildcard certificate *.exemple.com
#
# Note: Certificate should stay disabled until shou have performed zone delegation

provider "aws" {
}

module "zone_app" {
  source = "../.."

  zone_name = "exemple.com"

  certificate = {
    enabled = true

    domain_name = "*."
    subject_alternative_names = []
  }
}
