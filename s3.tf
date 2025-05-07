resource "aws_s3_bucket" "codepipeline_artifact_store" {
  bucket = "my-codepipeline-artifact-bucket-omar-20250507"
  force_destroy = true
  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
