/*O scale in ou scale out dentro do AutoScaler tem uma comunicacao com o Auto Scaling Group
dentro da AWS, porem, quando um processo de scale in ocorre, e necessario DRENAR os pods
para outras instancias e isso, o kubernetes nao gerencia. E necessario a instalacao de
um recurso chamado NODE TERMINATION que ficara responsavel pela drenagem dos pods.
Esse arquivo visa criar esse recurso e suas dependencias.

SQS = para enfileirar as instancias que serao desligadas
*/

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "node_termination_queue_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:${data.aws_region.current}:${data.aws_caller_identity.current.current}:NodeTerminationQueue"]
  }
}

data "aws_iam_policy_document" "node_termination_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_sqs_queue" "node_termination" {
  name                      = "NodeTerminationQueue"
  message_retention_seconds = 300
  policy                    = data.aws_iam_policy_document.node_termination_queue_policy.json

  tags = var.tags
}

resource "aws_iam_role" "instance_role" {
  name               = "nsse-production-node-termination-role"
  assume_role_policy = data.aws_iam_policy_document.node_termination_trust_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
  ]
}

data "aws_iam_policy_document" "node_termination" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstances",
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"
    ]
  }
}

resource "aws_iam_policy" "node_termination" {
  name   = "nsse-production-node-termination-policy"
  policy = data.aws_iam_policy_document.node_termination.json
}

resource "aws_iam_role_policy_attachment" "node_termination" {
  policy_arn = aws_iam_policy.node_termination.arn
  role       = aws_iam_role.instance_role.name
}


resource "aws_autoscaling_lifecycle_hook" "node_termination" {
  name                    = "NodeTerminationNotification"
  autoscaling_group_name  = module.ec2_workers_instances.auto_scaling_group.name
  default_result          = "CONTINUE"
  heartbeat_timeout       = 300
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
  notification_target_arn = aws_sqs_queue.node_termination.arn
  role_arn                = aws_iam_role.instance_role.arn

}
