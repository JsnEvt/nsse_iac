data "archive_file" "lambda" {
  type        = var.lambda_order_confirmed.package_type
  source_dir  = "${path.module}/${var.lambda_order_confirmed.source_dir}"
  output_path = "${path.module}/${var.lambda_order_confirmed.output_path}"
}

resource "aws_lambda_function" "order_confirmed" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "${path.module}/${var.lambda_order_confirmed.filename}"
  function_name    = var.lambda_order_confirmed.function_name
  role             = aws_iam_role.order_confirmed_lambda_role.arn
  handler          = var.lambda_order_confirmed.handler
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = var.lambda_order_confirmed.runtime
  #definindo as layers:
  layers = [aws_lambda_layer_version.node_modules.arn]


  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = data.aws_subnets.private_subnets.ids
    security_group_ids = [aws_security_group.postgresql.id]
  }

  environment {
    variables = {
      RDS_PROXY_ENDPOINT = aws_db_proxy.this.endpoint,
      RDS_SECRET_ARN     = aws_rds_cluster.this.master_user_secret[0].secret_arn
      SNS_TOPIC_ARN      = aws_sns_topic.order_confirmed_topic.arn
      RDS_DATABASE_NAME  = aws_rds_cluster.this.database_name
    }
  }
}

//criando a url para ser invocado pela API Gateway
resource "aws_lambda_function_url" "order_confirmed" {
  function_name      = aws_lambda_function.order_confirmed.function_name
  authorization_type = "AWS_IAM"
}

//para o uso da autorizacao (AWS_IAM), um usuario foi criado, como exemplo 
//no console da AWS para extracao da security credentials. 
//Estes mesmos dados foi informado no programa de teste de requisicoes como 
//o postman ou insomnia, usando a url criada com este recurso acima 
