resource "aws_s3_bucket" "backend" {
  bucket = var.s3_bucket
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "backend" {
  name         = var.dynamo_db.name
  billing_mode = var.dynamo_db.billing_mode
  hash_key     = var.dynamo_db.hash_key

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
}
