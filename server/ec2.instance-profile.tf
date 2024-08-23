/*
para nao usar credenciais dentro de instancias EC2, usamos instance_profile
que consiste na criacao de uma role com diversas policies atreladas
a instance role e atribuido a um instance profile e o instance profile e 
atrituido a instancia ec2

dessa forma definimos quais instancias terao acesso a um determinado recurso
dentro do provedor cloud
*/

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "instance_role" {
  name = var.ec2_resources.instance_role
  # path               = "/" //para departamentalizar o usuario, caso necessario
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.ec2_resources.instance_profile
  role = aws_iam_role.instance_role.name
}
