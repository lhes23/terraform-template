provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "../../modules/vpc"
  region     = var.region
  vpc_az     = var.vpc_az
  cidr_block = "10.0.0.0/16"
}

module "sg" {
  source = "../../modules/security-groups"
  vpc_id = module.vpc.id
}

module "tg" {
  source   = "../../modules/target-groups"
  app_name = var.app_name
  vpc_id   = module.vpc.id
}


module "alb" {
  source             = "../../modules/load-balancer"
  lb_name            = "${var.app_name}-alb"
  load_balancer_type = "application"
  lb_sg_ids          = [module.sg.lb_sg_id]
  lb_subnets         = module.vpc.public_subnet_ids
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
  image_id                    = "ami-01811d4912b4ccb26"
  instance_type               = "t2.micro"
  key_name                    = "llr-keypair"
  security_groups             = [module.sg.ec2_sg_id]
  associate_public_ip_address = true
}


module "asg" {
  source                  = "../../modules/auto-scaling-group"
  asg_name                = "${var.app_name}-asg"
  max_size                = 3
  desired_capacity        = 2
  min_size                = 2
  vpc_zone_identifier     = module.vpc.public_subnet_ids
  target_group_arns       = [module.tg.arn]
  launch_template_id      = module.lt.launch_template_id
  launch_template_version = "$Latest"
  instance_name_tag       = "${var.app_name}-terra"
}