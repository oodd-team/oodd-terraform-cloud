resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = "your-public-key"
}

resource "aws_instance" "bastion_host" {
  ami                         = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (region-specific)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "bastion-host"
  }
}