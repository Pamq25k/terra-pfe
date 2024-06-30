variable "domain" {
  description = "Domain name to be used"
  type        = string
  default     = "definitelynotpwc.com"
}

variable "zone_id" {
  description = "Hosted zone ID if resoucre already exists and needs to be imported"
  type        = string
  default     = "Z081464211ZI23N28ATRH"
}
