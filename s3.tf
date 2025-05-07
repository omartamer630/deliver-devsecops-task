resource "aws_s3_bucket" "codepipeline_artifact_store" {
  bucket        = "my-codepipeline-artifact-bucket-omar-20250507"
  force_destroy = true
  tags = {
    Env   = var.environment[0]
    Owner = var.environment[1]
  }
}
# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "artifact_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.codepipeline_artifact_store.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

