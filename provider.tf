provider "aws" {
  region = local.config_data.region
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}