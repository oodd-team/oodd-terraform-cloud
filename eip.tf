# Elastic IP 생성
resource "aws_eip" "nestjs_eip" {
  domain   = "vpc"
  tags = {
    Name = "nestjs-app-eip"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.nestjs_instance.id
  allocation_id = aws_eip.nestjs_eip.id
}