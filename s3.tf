resource "aws_s3_bucket" "codepipeline-artifacts" {
  bucket = "codepipeline-artifacts-sandboxx"
  acl = "private"

}