data "http" "aws_ip_ranges" {
  url = "https://ip-ranges.amazonaws.com/ip-ranges.json"
}


# CloudFront IP 대역 필터링
locals {
  cloudfront_ips = [
    for prefix in jsondecode(data.http.aws_ip_ranges.response_body).prefixes :
    prefix.ip_prefix if prefix.service == "CLOUDFRONT"
  ]

  # 보안 그룹 수 계산
  num_security_groups = ceil(length(local.cloudfront_ips) / 60)
}

output "cloudfront_ips" {
  value = local.cloudfront_ips
}

# dev 환경 보안 그룹 생성
resource "aws_security_group" "dev_sg" {
  name        = "${var.app_name}-dev-sg"
  description = "Security group for dev environment"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # 모든 아웃바운드 허용
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.config_data.aws.allowed_ips
  }
}



# 동적으로 보안 그룹과 규칙 생성
resource "aws_security_group" "cloudfront_sg" {
  count       = local.num_security_groups
  name        = "cloudfront-sg-${count.index + 1}"
  description = "Security group for CloudFront IPs ${count.index + 1}"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 각 보안 그룹에 60개씩 IP 대역 할당
resource "aws_security_group_rule" "cloudfront_inbound" {
  count             = length(local.cloudfront_ips)
  security_group_id = aws_security_group.cloudfront_sg[floor(count.index / 60)].id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [local.cloudfront_ips[count.index]]
}


# Security Group 생성 (ALB용)
resource "aws_security_group" "alb_sg" {
  name        = "${var.app_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}