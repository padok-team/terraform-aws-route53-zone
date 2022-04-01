variable "tags" {
  description = "Tags that will be added to resources in the module that support it"
  type        = map(string)
  default     = {}
}

variable "certificate" {
  description = "Certificate to be created for the zone. Domain and SANS should end with a \".\" and exclude the zone name."
  type = object({
    domain_name               = string
    subject_alternative_names = list(string)
  })
  default = null
}

variable "zone" {
  description = "Object describing the zone where the certificate should be created"
  type = object({
    name = string
    id   = string
  })
  default = null
}
