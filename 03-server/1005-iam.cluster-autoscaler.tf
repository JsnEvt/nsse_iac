/*
o kubernetes tem um recurso dentro do repositorio do github que permite que trabalhamos com 
o autoscaler dentro do cluster k8s. Isso fornece a possibilidade de fazermos scale-in
ou scale-out nos pods quando conveniente. Ao inves de escalar instancias como o ASG da AWS,
o processo escala pods que ficam pendentes conforme a demanda cresce ou diminui.

Abaixo comecaremos definindo as permissoes e o tagueamento:

*/

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
    ]
  }
  statement {
    effect    = "Allow"
    resources = [module.ec2_workers_instances.auto_scaling_group_arn]
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = var.worker_autoscaling_group.cluster_auto_scaler_policy_name
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = aws_iam_role.instance_role.name
}


