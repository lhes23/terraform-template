variable "lb_name" {
  type        = string
  description = "Name of the Application Load Balancer"
}

variable "lb_sg_ids" {
  type        = list(string)
  description = "Security Group IDs for ALB"
}

variable "lb_subnets" {
  type        = list(string)
  description = "Subnet IDs for ALB"
}

variable "load_balancer_type" {
  type = string
  description = "Type of load balancer"
}