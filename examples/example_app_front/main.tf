# Zone with certificate for classics: exemple.com and www.exemple.com
#
# Note: Certificate should stay disabled until you have performed zone delegation

provider "aws" {
}

module "zone_app_front" {
  source = "../.."

  zone_name = "example.com"

  certificate = {
    enabled = true

    domain_name = "www."
    subject_alternative_names = [
        ""
    ]
  }
}
