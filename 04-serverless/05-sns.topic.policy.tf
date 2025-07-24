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
      "sns:SetTopicAttributes",
      "sns:DeleteTopic",
      "sns:ListSubscriptionsByTopic",
      "sns:GetTopicAttibutes",
      "sns:AddPermission",
      "sns:Subscribe"
    ]
  }
}

#Qualquer entidade da AWS ("*") tem permissão para executar várias ações no SNS, em qualquer tópico.
