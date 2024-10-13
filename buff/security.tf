resource "aws_security_group" "dev_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["211.206.30.203/32"] # 허락된 IP 그룹 (dev 환경)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }
}

resource "aws_security_group" "prod_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP 허용 (prod 환경)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-sg"
  }
}

resource "aws_security_group_rule" "allow_eks_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dev_sg.id # dev EKS 보안 그룹
  source_security_group_id = aws_security_group.db_sg.id  # RDS 보안 그룹
}

resource "aws_security_group_rule" "allow_eks_to_rds_prod" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prod_sg.id # prod EKS 보안 그룹
  source_security_group_id = aws_security_group.db_sg.id   # RDS 보안 그룹
}