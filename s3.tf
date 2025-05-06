resource "aws_s3_bucket" "codepipeline_artifact_store" {
  bucket = "my-tf-test-bucket"

  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
