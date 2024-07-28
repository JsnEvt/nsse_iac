module "ec2_control_plane_instances" {
  source                 = "./modules/ec2"
  key_name               = aws_key_pair.this.key_name
  instance_profile_name  = aws_iam_instance_profile.instance_profile.name
  vpc_zone_identifier    = data.aws_subnet.private_subnets.id
  image_id               = data.aws_ami.this.image_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  launch_template = {
    name                                 = var.control_plane_launch_template.name
    disable_api_stop                     = var.control_plane_launch_template.disable_api_stop
    disable_api_termination              = var.control_plane_launch_template.disable_api_termination
    instance_type                        = var.control_plane_launch_template.instance_type
    instance_initiated_shutdown_behavior = var.control_plane_launch_template.instance_initiated_shutdown_behavior
    ebs = {
      size                  = var.control_plane_launch_template.ebs.size
      delete_on_termination = var.control_plane_launch_template.ebs.delete_on_termination
    }
  }
  auto_scaling_group = {
    name                      = var.control_plane_autoscaling_group.name
    max_size                  = var.control_plane_autoscaling_group.max_size
    min_size                  = var.control_plane_autoscaling_group.min_size
    desired_capacity          = var.control_plane_autoscaling_group.desired_capacity
    health_check_grace_period = var.control_plane_autoscaling_group.health_check_grace_period
    health_check_type         = var.control_plane_autoscaling_group.health_check_type
    instance_maintenance_policy = {
      min_healthy_percentage = var.control_plane_autoscaling_group.instance_maintenance_policy.min_healthy_percentage
      max_healthy_percentage = var.control_plane_autoscaling_group.instance_maintenance_policy.max_healthy_percentage
    }
  }
  tags = var.tags
}
