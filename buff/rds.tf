resource "aws_db_instance" "main_db" {
  identifier             = "oodd-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "dbadmin"
  password               = "YourSecurePassword"
  db_name                = "oodd" # 기본 DB 이름
  multi_az               = false
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "oodd-db-instance"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 5432 # PostgreSQL 기본 포트
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["211.206.30.203/32"] # 허락된 IP 그룹
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}