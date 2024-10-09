resource "aws_autoscaling_group" "asg" {
  name                = var.asg_name
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns   = var.target_group_arns
  health_check_type   = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  min_elb_capacity = 1

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.instance_name_tag
    propagate_at_launch = true
  }
}


output "id" {
  description = "The ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.id
}

output "name" {
  value = aws_autoscaling_group.asg.name
}