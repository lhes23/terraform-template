variable "region" {
  type        = string
  description = "Region of the Infrastructure"
}

variable "vpc_az" {
  type        = list(string)
  description = "Availability Zones"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block of the vpc"
}

variable "app_name" {
  type        = string
  description = "App name"
}

variable "image_id" {
  type        = string
  description = "AMI of the EC2"
}

variable "instance_type" {
  type        = string
  description = "Instance Type of the EC2"
}

variable "key_name" {
  type        = string
  description = "keypair name"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instance"
}
variable "min_size" {
  type        = number
  description = "Minimum number of instance"
}
variable "desired_capacity" {
  type        = number
  description = "Desired capacity number of instance"
}

variable "environment" {
  type        = string
  description = "The environment of the application"
}