resource "aws_codebuild_project" "code_preparation" {
  name         = "my-codebuild-code-preparation"
  service_role = aws_iam_role.codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "1.5.6"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"

  }

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
resource "aws_codebuild_project" "code_plan" {
  name         = "my-codebuild-code-plan"
  service_role = aws_iam_role.codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "STAGE_TYPE"
      value = "plan"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
resource "aws_codebuild_project" "code_scan" {
  name         = "my-codebuild-code-scan"
  service_role = aws_iam_role.codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "STAGE_TYPE"
      value = "scan"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
resource "aws_codebuild_project" "code_apply" {
  name         = "my-codebuild-code-apply"
  service_role = aws_iam_role.codebuild-role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "STAGE_TYPE"
      value = "apply"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
