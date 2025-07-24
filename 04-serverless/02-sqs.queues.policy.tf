data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["905418339132"]
    }

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:*"]
    resources = ["*"]
  }
}

#Está criando um documento de política IAM que permite que a conta AWS 905418339132 e o
#serviço SNS (sns.amazonaws.com) realizem qualquer ação (sqs:*) em qualquer recurso do SQS (*).
