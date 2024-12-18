# RDS 인스턴스에 새로운 보안 그룹 연결
resource "aws_db_instance" "oodd_db" {
  identifier          = "oodd-db"
  instance_class      = "db.t4g.micro"
  allocated_storage   = 20
  engine              = "mysql"
  username            = "root"
  publicly_accessible = true
  password            = local.config_data.aws.db_password
  availability_zone = "ap-northeast-2a"
  skip_final_snapshot = true
  # 기존 RDS 인스턴스의 속성을 유지하면서 보안 그룹만 변경
  apply_immediately = true
  vpc_security_group_ids = [
    aws_security_group.dev_rds_sg.id
  ]
}