data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["905418339132"]
    }

    actions   = ["sqs:*"]
    resources = ["*"]
  }
}
