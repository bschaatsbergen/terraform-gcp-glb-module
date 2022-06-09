variable "name" {
  type        = string
  description = "Name of the service"
}

variable "domain" {
  type        = string
  description = "Domain of the service"
  default     = null
}

variable "network_endpoint_groups" {
  type        = list(map(string))
  description = "Network endpoint groups to create"
  default     = []
}

variable "project" {
  type        = string
  description = "Project where the Cloud Run resources are being created"
  default     = "null"
}
