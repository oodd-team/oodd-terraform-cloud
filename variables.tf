variable "config" {
  description = "Configuration from config.yaml"
  type        = any
  default     = {}
}

variable "app_name" {
  default = "nestjs-app"
}

locals {
  config_data = yamldecode(file("./config.yaml"))
}