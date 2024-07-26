resource "aws_dynamodb_table" "this" {
  name         = var.dynamo_table.name
  billing_mode = var.dynamo_table.billing_mode
  hash_key     = var.dynamo_table.hash_key

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
}
