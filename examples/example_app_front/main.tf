# Zone with certificate for classics: exemple.com and www.exemple.com
#
# Note: Certificate should stay disabled until shou have performed zone delegation

provider "aws" {
}

module "zone_app_front" {
  source = "../.."

  zone_name = "exemple.com"

  certificate = {
    enabled = true

    domain_name = "www."
    subject_alternative_names = [
        "."
    ]
  }
}