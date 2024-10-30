variable "config" {
  description = "Configuration from config.yaml"
  type        = any
  default     = {}
}

variable "environment" {
  description = "Deployment environment: dev or prod"
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the environment"
  type        = string
}


variable "app_name" {
  default = "nestjs-app"
}


variable "port" {
  description = "Application port for the environment"
  type        = number
}

locals {
  config_data = yamldecode(file("./config.yaml"))
}