data "aws_iam_policy_document" "sns_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "sns_topic_role" {
  name                = var.order_confirmed_topic.role_name
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonSNSRole"]
  assume_role_policy  = data.aws_iam_policy_document.sns_trust_policy.json
}

#O serviço SNS (sns.amazonaws.com) tem permissão para assumir essa role.
#Essa política permite que o serviço SNS assuma essa role para agir com as permissões atribuídas a ela.

#Em resumo simples:
#Criar uma role IAM para o serviço SNS assumir, com permissões padrões para SNS, e com a política que
#autoriza o serviço SNS a assumir essa role.
