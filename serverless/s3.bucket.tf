resource "aws_s3_bucket" "nsse" {
  bucket = var.s3_application_bucket_name

  tags = var.tags
}
