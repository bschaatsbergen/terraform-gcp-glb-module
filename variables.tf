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

variable "health_check" {
  type = object({
    request_path       = string
    check_interval_sec = number
    timeout_sec        = number
  })
  description = "Health check configuration"
  default = {
    request_path       = "/"
    check_interval_sec = 5
    timeout_sec        = 5
  }
}

variable "project" {
  type        = string
  description = "Project where the Cloud Run resources are being created"
  default     = "null"
}
