//criando o bucket para armazenar os logs dos patches feitos pelo systems manager

resource "aws_s3_bucket" "logs" {
  bucket        = var.logs_bucket.bucket
  force_destroy = var.logs_bucket.force_destroy
  tags          = var.tags
}

//para que as instancias tenham acesso ao s3, o codigo abaixo concede
//as permissoes 

resource "aws_s3_bucket_policy" "allow_access_from_instances" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.allow_access_from_instances.json
}

data "aws_iam_policy_document" "allow_access_from_instances" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.instance_role.arn]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/*",
    ]
  }
}
