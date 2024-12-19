# Need to explicitly add the variables because it runs, before everything else
terraform {
  backend "s3" {
    bucket         = "terraform-template-state-bucket"
    key            = "live/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "live_vpc" {
  source     = "../../modules/vpc"
  region     = var.region
  vpc_az     = var.vpc_az
  cidr_block = var.cidr_block
}

module "sg" {
  source = "../../modules/security-groups"
  vpc_id = module.live_vpc.id
}

module "tg" {
  source   = "../../modules/target-groups"
  app_name = var.app_name
  vpc_id   = module.live_vpc.id
}


module "alb" {
  source             = "../../modules/load-balancer"
  lb_name            = "${var.app_name}-alb"
  load_balancer_type = "application"
  lb_sg_ids          = [module.sg.lb_sg_id]
  lb_subnets         = module.live_vpc.public_subnet_ids
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.tg.arn
  }
}

module "lt" {
  source                      = "../../modules/launch-template"
  lt_name                     = "${var.app_name}-lt"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [module.sg.ec2_sg_id]
  user_data                   = filebase64("${path.module}/userdata.sh")
  associate_public_ip_address = true
  instance_tags = {
    ScheduleShutdown = "True"
  }
}

module "asg" {
  source                    = "../../modules/auto-scaling-group"
  asg_name                  = "${var.app_name}-asg"
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  vpc_zone_identifier       = module.live_vpc.public_subnet_ids
  target_group_arns         = [module.tg.arn]
  launch_template_id        = module.lt.launch_template_id
  launch_template_version   = "$Latest"
  instance_name_tag         = "${var.app_name}-terra"
  health_check_type         = "ELB"
  health_check_grace_period = 300
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "${var.app_name}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "${var.app_name}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = module.asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.app_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.app_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in_high" {
  alarm_name          = "${var.app_name}-network-in-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50000000 # 50 MB
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in_low" {
  alarm_name          = "${var.app_name}-network-in-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10000000 # 10 MB
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.name
  }
}
