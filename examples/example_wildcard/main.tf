# Zone with a wildcard certificate *.exemple.com
#
# Note: Certificate should stay disabled until shou have performed zone delegation

provider "aws" {
  region = "eu-west-3"
}

module "zone_app" {
  source = "../.."

  zone_name = "libtime-ex-wildcard.forge-demo.fr"

  certificate = {
    enabled = false

    domain_name = "*."
    subject_alternative_names = []
  }
}
