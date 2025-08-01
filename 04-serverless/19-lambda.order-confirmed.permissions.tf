resource "aws_iam_role" "order_confirmed_lambda_role" {
  name               = var.lambda_order_confirmed.role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

//precisamos conceder permissao de acesso para a lambda a secrets e ao topico 
resource "aws_iam_policy" "order_confirmed_lambda_policy" {
  name        = var.lambda_order_confirmed.policy_name
  description = "Policy for Lambda"
  policy = jsonencode({
    Version = "2012-10-17"
    Statment = [{
      Effect = "Allow",
      Action = [
        "secretsmanager:GetSecretValue",
        "sns:Publish"
      ],
      Resource = [aws_rds_cluster.this.master_user_secret[0].secret_arn,
      aws_sns_topic.order_confirmed_topic.arn]
    }]
  })
}

//role para permitir que a lambda rode dentro de uma vpc
resource "aws_iam_role_policy_attachment" "order_confirmed_lambda_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.order_confirmed_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "order_confirmed_lambda_custom" {
  policy_arn = aws_iam_policy.order_confirmed_lambda_policy.arn
  role       = aws_iam_role.order_confirmed_lambda_role.name
}

#1-criou-se a policy concedendo as pemissoes
#2-criou-se o assume role para a lambda
#3-anexou uma policy gerenciada
#4-atachou a policy com a role



