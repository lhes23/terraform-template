resource "aws_lb_target_group" "tg" {
  name     = "${var.app_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


variable "app_name" {
  description = "App name"
}

variable "vpc_id" {
  description = "VPC ID"
}


output "arn" {
  value = aws_lb_target_group.tg.arn
}