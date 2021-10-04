resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = var.bucket_name_art
  acl    = "private"
}