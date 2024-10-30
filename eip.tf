# Elastic IP 생성
resource "aws_eip" "nestjs_eip" {
  instance = aws_instance.nestjs_instance.id
  domain   = "vpc"
  tags = {
    Name = "nestjs-app-eip"
  }
}