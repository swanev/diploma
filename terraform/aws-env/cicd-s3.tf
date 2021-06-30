resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "school16-covid-diploma-artifacts"
  acl    = "private"
}