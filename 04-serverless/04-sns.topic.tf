#O order_confirmed_topic tem duas inscricoes: ProductStockQueue e InvoiceQueue
#o recurso abaixo cria o topic para amarrar os dois mas, quem amarra e outro recurso
#aws_sns_topic_subscription.order_confirmed filtrando pela lista das filas descritas em 
#subscritions no arquivo de variaveis

resource "aws_sns_topic" "order_confirmed_topic" {
  name                             = var.order_confirmed_topic.name
  sqs_success_feedback_sample_rate = var.order_confirmed_topic.sqs_success_feedback_sample_rate
  sqs_success_feedback_role_arn    = aws_iam_role.sns_topic_role.arn
  sqs_failure_feedback_role_arn    = aws_iam_role.sns_topic_role.arn
  policy                           = data.aws_iam_policy_document.sns_policy.json

  tags = var.tags
}


