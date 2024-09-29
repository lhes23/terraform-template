variable "lt_name" {
  type = string
  description = "Name of the Launch Template"
}

variable "image_id" {
  type = string
  description = "Application Machine Image"
}

variable "instance_type" {
  type = string
  description = "The EC2 instance type"
}


variable "key_name" {
  type        = string
  description = "The name of the key pair"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address with the instances"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs to associate with the instances"
}

variable "user_data" {
  type        = string
  description = "The Base64 encoded user data script"
  default     = ""
}

variable "instance_tags" {
  type        = map(string)
  description = "A map of tags to assign to the instances"
  default     = {}
}
