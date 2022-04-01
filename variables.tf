variable "tags" {
  description = "Tags that will be added to resources in the module that support it"
  type        = map(string)
  default     = {}
}

variable "zone" {
  description = "DNS name of the zone (e.g. exemple.com)."
  type = object({
    create = optional(bool)
    name   = string
  })
  default = null
}

variable "certificate" {
  description = "Certificate to be created for the zone. Domain and sans should end with a \".\" and exclude the zone name."
  type = object({
    enabled                   = optional(bool)
    enabled_clone             = optional(bool)
    domain_name               = string
    subject_alternative_names = optional(list(string))
  })
  default = null
}

variable "delegations" {
  description = "Map { <sub_zone> => [<name_servers>] in order to setup delegations. For <sub_zones> just put the sub domain."
  type        = map(list(string))
  default     = {}
}
