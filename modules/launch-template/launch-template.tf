resource "aws_launch_template" "lt" {
  name          = var.lt_name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.security_groups
  }

  user_data = var.user_data

  tag_specifications {
    resource_type = "instance"
    tags = var.instance_tags
  }
}

output "launch_template_id" {
  value = aws_launch_template.lt.id
  description = "The ID of the created launch template"
}
