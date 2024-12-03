
# CodeDeploy DEV 애플리케이션 생성
resource "aws_codedeploy_app" "dev_nestjs_app" {
  name             = "${var.app_name}-dev"
  compute_platform = "Server"
}
# CodeDeploy DEV 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "dev_deployment_group" {
  app_name              = aws_codedeploy_app.dev_nestjs_app.name
  deployment_group_name = "${var.app_name}-dev-group"
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

# CodeDeploy PROD 애플리케이션 생성
resource "aws_codedeploy_app" "prod_nestjs_app" {
  name             = "${var.app_name}-prod"
  compute_platform = "Server"
}

# CodeDeploy PROD 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "prod_deployment_group" {
  app_name              = aws_codedeploy_app.prod_nestjs_app.name
  deployment_group_name = "${var.app_name}-prod-group"
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