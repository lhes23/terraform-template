provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "../../modules/vpc"
  vpc_name = "${var.app_name}-staging"
  region     = var.region
  vpc_az     = var.vpc_az
  cidr_block = var.cidr_block
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
  image_id                    = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [module.sg.ec2_sg_id]
  user_data                   = filebase64("${path.module}/userdata.sh")
  associate_public_ip_address = true
  instance_tags = {
    Name = var.app_name
    Env = "staging"
  }
}


module "asg" {
  source                  = "../../modules/auto-scaling-group"
  asg_name                = "${var.app_name}-asg"
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  min_size                = var.min_size
  vpc_zone_identifier     = module.vpc.public_subnet_ids
  target_group_arns       = [module.tg.arn]
  launch_template_id      = module.lt.launch_template_id
  launch_template_version = "$Latest"
  instance_name_tag       = "${var.app_name}-server"
    health_check_grace_period = 300
  health_check_type = "ELB"
}

module "bastion" {
  source            = "../../modules/bastion"
  ami_id            = var.image_id
  instance_type     = "t3.micro"
  staging_subnet_id = module.vpc.public_subnet_ids[0]
  key_name          = var.key_name
  ssh_private_key   = var.ssh_private_key
  staging_vpc_cidr  = module.vpc.cidr_block
  live_vpc_cidr     = "10.1.0.0/16"
}
