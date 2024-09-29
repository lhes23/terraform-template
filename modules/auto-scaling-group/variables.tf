# modules/asg/variables.tf
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs to associate with the ASG"
  type        = list(string)
}

variable "health_check_type" {
  description = "The type of health check to use for the ASG"
  type        = string
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "The time in seconds after which health checks should be initiated"
  type        = number
  default     = 300
}

variable "launch_template_id" {
  description = "The ID of the launch template to use"
  type        = string
}

variable "launch_template_version" {
  description = "The version of the launch template to use"
  type        = string
  default     = "$Latest"
}

variable "instance_name_tag" {
  description = "Tag for the instance names"
  type        = string
}
