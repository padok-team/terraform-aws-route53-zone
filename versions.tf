terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.63"
      configuration_aliases = [aws.clone]
    }
  }

  experiments = [module_variable_optional_attrs]
}
