variable "tags" {
  description = "Tag that will be added to resources in the module that support it"
  default     = {}
  type        = map(string)
}

variable "certificate" {
  description = "Certificate to be created for the zone. Domain and SANS should end with a \".\" and exclude the zone name."
  default     = null
  type = object({
    domain_name               = string
    subject_alternative_names = list(string)
  })
}

variable "zone" {
  description = "Object describing the zone where the certificate should be created"
  default     = null
  type = object({
    name = string
    id   = string
  })
}
