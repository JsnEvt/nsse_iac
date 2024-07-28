resource "aws_launch_template" "control_plane" {
  name                                 = var.control_plane_launch_template.name
  disable_api_stop                     = var.control_plane_launch_template.disable_api_stop
  disable_api_termination              = var.control_plane_launch_template.disable_api_termination
  instance_type                        = var.control_plane_launch_template.instance_type
  key_name                             = aws_key_pair.this.key_name
  image_id                             = data.aws_ami.this.image_id
  instance_initiated_shutdown_behavior = var.control_plane_launch_template.instance_initiated_shutdown_behavior
  vpc_security_group_ids               = [aws_security_group.allow_ssh.id]

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = var.control_plane_launch_template.ebs.size
      delete_on_termination = var.control_plane_launch_template.ebs.delete_on_termination
    }
  }

  iam_instance_profile {
    name = var.aws_iam_instance_profile.instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    # tags = ""
  }
}
