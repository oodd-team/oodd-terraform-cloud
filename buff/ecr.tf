resource "aws_ecr_repository" "nestjs_repo" {
  name                 = "nestjs-app"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "nestjs-app-repo"
  }
}