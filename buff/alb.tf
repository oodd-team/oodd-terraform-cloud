resource "aws_lb" "dev_alb" {
  name               = "dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev_sg.id]
  subnets            = [aws_subnet.public_subnet.id]

  tags = {
    Name = "dev-alb"
  }
}

resource "aws_lb" "prod_alb" {
  name               = "prod-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.prod_sg.id]
  subnets            = [aws_subnet.public_subnet.id]

  tags = {
    Name = "prod-alb"
  }
}

resource "aws_lb_listener" "dev_http_listener" {
  load_balancer_arn = aws_lb.dev_alb.arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}

resource "aws_lb_listener" "prod_http_listener" {
  load_balancer_arn = aws_lb.prod_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }
}