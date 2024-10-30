# 기본 VPC 가져오기
data "aws_vpc" "default" {
  default = true
}

# 기본 VPC에 있는 모든 서브넷 가져오기
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  subnet_ids = tolist([for subnet in data.aws_subnets.default_subnets.ids : subnet])
}
