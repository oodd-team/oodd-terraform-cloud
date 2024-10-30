
# CodeDeploy 애플리케이션 생성
resource "aws_codedeploy_app" "nestjs_app" {
  name             = "${var.app_name}-${var.environment}"
  compute_platform = "Server"
}

# CodeDeploy 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name              = aws_codedeploy_app.nestjs_app.name
  deployment_group_name = "${var.app_name}-${var.environment}-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type   = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      value = "oodd-instance"
      type  = "KEY_AND_VALUE"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}