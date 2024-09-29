variable "region" {
  type        = string
  description = "Region of the Infrastructure"
}

variable "vpc_az" {
  type        = list(string)
  description = "Availability Zones"
}

variable "app_name" {
  type        = string
  description = "App name"
}