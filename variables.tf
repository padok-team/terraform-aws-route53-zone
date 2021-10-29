variable "tags" {
  description = "Tag that will be added to resources in the module that support it"
  default     = {}
  type        = map(string)
}

variable "zone_name" {
  description = "DNS name of the zone (e.g. exemple.com)."
  default     = null
  type        = string
}

variable "certificate" {
  description = "Certificate to be created for the zone. Domain and sans should end with a \".\" and exclude the zone name."
  default     = null
  type        = object({
    enabled                   = bool
    domain_name               = string
    subject_alternative_names = list(string)
  })
}

variable "delegations" {
  description = "Map { <sub_zone> => [<name_servers>] in order to setup delegations. For <sub_zones> just put the sub domain."
  default     = {}
  type        = map(list(string))
}
