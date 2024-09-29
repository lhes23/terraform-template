variable "region" {
  type        = string
  description = "Region of the Infrastructure"
  default     = "ap-southeast-1"
}

variable "vpc_az" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}