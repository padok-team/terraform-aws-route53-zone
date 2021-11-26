# Zone with a wildcard certificate *.exemple.com
#
# Note: Certificate should stay disabled until shou have performed zone delegation

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

module "zone_root" {
  source = "../.."

  zone_name = "libtime-ex-root.forge-demo.fr"

  certificate = {
    enabled = false

    domain_name = "*."
    subject_alternative_names = []
  }

  # delegations = {
  #   "staging" = module.zone_staging.zone.name_servers
  #   "preprod" = module.zone_preprod.zone.name_servers
  # }
}

# module "zone_staging" {
#   source = "../.."

#   zone_name = join(".", ["staging", module.zone_root.zone["name"]])

#   certificate = {
#     enabled = true

#     domain_name = "*."
#     subject_alternative_names = []
#   }
# }

# module "zone_preprod" {
#   source = "../.."

#   zone_name = join(".", ["preprod", module.zone_root.zone["name"]])

#   certificate = {
#     enabled = true

#     domain_name = "*."
#     subject_alternative_names = []
#   }
# }
