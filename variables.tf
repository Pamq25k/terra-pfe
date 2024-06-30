variable "service-token" {
  description = "Value of service token for fleet server"
  type        = string
  default     = "AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE3MTg3NTk3NzE0NDk6NEFCRTBOTlhRSEtSRmZWSE1tRzNJZw"
}

variable "enrollment-token" {
  description = "Value of enrollment token for agents"
  type        = string
  default     = "WmNvT0xwQUJFdUZEd2s0bFYyWEM6RHNYb3FQa2NSdTZ0bjd5ZVFYZ2Y3Zw=="
}

variable "domain" {
  description = "Domain name to be used"
  type        = string
  default     = "definitelynotpwc.com"
}

variable "zone_id" {
  description = "Hosted zone ID if resource already exists and needs to be imported"
  type        = string
  default     = "Z081464211ZI23N28ATRH"
}
