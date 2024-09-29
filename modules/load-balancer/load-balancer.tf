resource "aws_lb" "alb" {
  name               = var.lb_name
  load_balancer_type = var.load_balancer_type
  security_groups    = var.lb_sg_ids
  subnets            = var.lb_subnets
}

# Output the ALB DNS name
output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "arn" {
  value = aws_lb.alb.arn
}
