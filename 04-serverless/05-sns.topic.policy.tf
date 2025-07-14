data "aws_iam_policy_document" "sns_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["*"]

    actions = [
      "sns:Publish",
      "sns:RemovePermission",
      "sns: SetTopicAttributes",
      "sns:DeleteTopic",
      "sns:ListSubscriptionsByTopic",
      "sns:GetTopicAttibutes",
      "sns:AddPermission",
      "sns:Subscribe"
    ]
  }
}
