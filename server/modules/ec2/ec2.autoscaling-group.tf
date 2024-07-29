
resource "aws_autoscaling_group" "this" {
  name                      = var.auto_scaling_group.name
  max_size                  = var.auto_scaling_group.max_size
  min_size                  = var.auto_scaling_group.min_size
  desired_capacity          = var.auto_scaling_group.desired_capacity
  health_check_grace_period = var.auto_scaling_group.health_check_grace_period
  health_check_type         = var.auto_scaling_group.health_check_type
  # vpc_zone_identifier       = data.aws_subnet.private_subnets.id
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


  tag {
    key                 = "Project"
    value               = var.tags.Project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.tags.Environment
    propagate_at_launch = false
  }
}
