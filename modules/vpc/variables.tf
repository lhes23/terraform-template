variable "region" {
  type        = string
  description = "Region of the Infrastructure"
  default = "ap-southeast-1"
}

variable "vpc_az" {
  type        = list(string)
  description = "Availability Zones"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "cidr_block" {
  type = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  description = "The name of the VPC"
}