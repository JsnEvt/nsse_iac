data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

#endereco obtido na documentacao
#ele pegara todos os servidores de edge locations para que o cloudfront
#possa aceitar essa origem.
