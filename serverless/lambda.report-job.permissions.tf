resource "aws_iam_role" "report_job_lambda_role" {
  name               = var.lambda_report_job.role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

//precisamos conceder permissao de acesso para a lambda a secrets e ao topico 
resource "aws_iam_policy" "report_job_lambda_policy" {
  name        = var.lambda_report_job.policy_name
  description = "Policy for Lambda"
  policy = jsonencode({
    Version = "2012-10-17"
    Statment = [{
      Effect = "Allow",
      Action = [
        "secretsmanager:GetSecretValue",
        "s3:GetObject",
      ],
      Resource = [aws_rds_cluster.this.master_user_secret[0].secret_arn,
        aws_secretsmanager_secret.documentdb.arn,
        "${aws_s3_bucket.this.arn}/*",
      aws_sns_topic.order_confirmed._topic.arn]
    }]
  })
}

//role para permitir que a lambda rode dentro de uma vpc
resource "aws_iam_role_policy_attachment" "report_job_lambda_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.report_job_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "report_job_lambda_custom" {
  policy_arn = aws_iam_policy.report_job_lambda_policy.arn
  role       = aws_iam_role.report_job_lambda_role.name
}




