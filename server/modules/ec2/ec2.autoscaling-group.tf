/*
o conteudo abaixo esta fazendo mencao ao arquivo de variaveis porem, para 
colocar no github, resolvi copia-lo pra ca
pq nao esta sendo definido os parametros default nesse arquivo de variaveis?
aqui se faz o uso de variaveis de input
quem estiver utilizando este modulo e que tera que fazer as especificacoes
este arquivo de variaveis e agnostico, ele nao sabe o que esta criando
ele ira criar um launch template e o asg para instancias control plane e 
workers e cada uma tera suas proprias definicoes
no arquivo do recurso a ser criado que utiliza este modulo tera uma referencia
apontando para esta pasta: source = "./modules/ec2"
os valores default das variaveis ja estao definidos no arquivo de variaveis
em que os recursos serao criados
isso evita a duplicacao de codigo
*/

locals {
  asg_tags_dictionary = [for key, value in var.auto_scaling_group.instance_tags : {
    key   = key
    value = value
  }]
}

resource "aws_autoscaling_group" "this" {
  name                      = var.auto_scaling_group.name
  max_size                  = var.auto_scaling_group.max_size
  min_size                  = var.auto_scaling_group.min_size
  desired_capacity          = var.auto_scaling_group.desired_capacity
  health_check_grace_period = var.auto_scaling_group.health_check_grace_period
  health_check_type         = var.auto_scaling_group.health_check_type
  # vpc_zone_identifier       = data.aws_subnet.private_subnets.ids
  vpc_zone_identifier = var.auto_scaling_group.vpc_zone_identifier


  launch_template {
    # name    = aws_launch_template.this.name
    name    = aws_launch_template.this.name
    version = "$latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = var.auto_scaling_group.instance_maintenance_policy.min_healthy_percentage
    max_healthy_percentage = var.auto_scaling_group.instance_maintenance_policy.max_healthy_percentage
  }

  dynamic "tag" {
    for_each = local.asg_tags_dictionary
    content {
      key                 = tag.value.key
      value               = tag.value.vlue
      propagate_at_launch = true
    }
  }

}
