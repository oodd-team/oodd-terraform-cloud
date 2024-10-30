# ALB 생성
resource "aws_lb" "nestjs_alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  
  subnets = local.subnet_ids

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# ALB Listener (HTTPS)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.nestjs_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy       = "ELBSecurityPolicy-2016-08"
  certificate_arn  = data.aws_acm_certificate.server_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nestjs_tg.arn
  }
}

# ALB Listener (HTTP -> HTTPS 리디렉션)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nestjs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

# Target Group 생성 (EC2 인스턴스를 대상으로)
resource "aws_lb_target_group" "nestjs_tg" {
  name     = "${var.app_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# EC2 인스턴스에 타겟 등록
resource "aws_lb_target_group_attachment" "nestjs_ec2" {
  target_group_arn = aws_lb_target_group.nestjs_tg.arn
  target_id        = aws_instance.nestjs_instance.id
  port             = 80
}