variable "config" {
  description = "Configuration from config.yaml"
  type        = any
  default     = {}
}

locals {
  config_data = yamldecode(file("./config.yaml"))
}