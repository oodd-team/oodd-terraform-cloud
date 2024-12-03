
# EC2 인스턴스 생성
resource "aws_instance" "nestjs_instance" {
  ami             = "ami-040c33c6a51fd5d96" # 사용하려는 AMI ID로 대체
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.dev_sg.name] # Dev 보안 그룹
  key_name        = "oodd"                           # SSH 접속용 키 페어
  root_block_device {
    volume_size = 30
  }
  tags = {
    Name        = "oodd-instance"
    Environment = "dev"
  }
}
