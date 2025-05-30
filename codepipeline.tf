
resource "aws_codestarconnections_connection" "github_connections_with_pipeline" {
  name          = "Github"
  provider_type = "GitHub"
  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = "devsecopspipeline"
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_artifact_store.bucket
    type     = "S3"
  }
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connections_with_pipeline.arn
        FullRepositoryId = "omartamer630/deliver-devsecops-task"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "preparation"

    action {
      name             = "preparation"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["preparation_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_preparation.name
      }
    }
  }
  stage {
    name = "Plan"

    action {
      name             = "plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["preparation_output"]
      output_artifacts = ["plan_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_plan.name
      }
    }
  }
  stage {
    name = "Scan"

    action {
      name             = "scan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["plan_output"]
      output_artifacts = ["scan_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_scan.name
      }
    }
  }
  stage {
    name = "Manual_Approval"

    action {
      name             = "manual_approval"
      category         = "Approval"
      owner            = "AWS"
      provider         = "Manual"
      input_artifacts  = []
      output_artifacts = []
      version          = "1"
      configuration = {
        CustomData = "Please verify the terraform plan output on the Plan stage and only approve this step if you see expected changes!"
      }
    }

  }
  stage {
    name = "Apply"

    action {
      name             = "apply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["scan_output"]
      output_artifacts = ["apply_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_apply.name
      }
    }
  }

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}

