# Zone with a wildcard certificate *.exemple.com
#
# Note: Certificate should stay disabled until you have performed zone delegation

provider "aws" {
  region = "eu-west-3"
}

module "zone_app" {
  source = "../.."

  zone_name = "example.com"

  certificate = {
    enabled = true

    domain_name = "*."
    subject_alternative_names = []
  }
}
