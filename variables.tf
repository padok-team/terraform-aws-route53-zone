
variable "name" {
  description = "DNS name of the zone (e.g. example.com)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = " (Optional) Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "declare_ns_records" {
  description = "Whether to declare NS records for the created zone"
  type        = bool
  default     = false
}

variable "root_zone_id" {
  description = "Route53 zone ID of root domain to add NS record for the created zone"
  type        = string
  default     = null
}
