resource "aws_iam_role" "rds_proxy_role" {
  name = var.rds_proxy.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "rds.amazonaws.com",
        }
      }
    ]
  })
}

#Crie uma role com o nome definido em var.rds_proxy.role_name, 
#e permita que o serviço rds.amazonaws.com (ou seja, o Amazon RDS) possa assumir essa role.
#Esse tipo de role é normalmente usado por serviços como RDS Proxy, que precisam de 
#permissões para acessar, por exemplo, Secrets Manager, CloudWatch, ou outros serviços em nome do RDS.

resource "aws_iam_policy" "rds_proxy_policy" {
  name        = var.rds_proxy.policy_name
  description = "Policy for RDS Proxy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statment = [{
      Effect = "Allow",
      Action = [
        "secretsmanager:GetSecretValue",
      ],
      Resource = aws_rds_cluster.this.master_user_secret[0].secret_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_policy" {
  policy_arn = aws_iam_policy.rds_proxy_policy.arn
  role       = aws_iam_role.rds_proxy_role.name
}
