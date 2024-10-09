variable "region" {
  description = "The AWS region where the resources should be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state."
  type        = string
  default     = "terraform-template-state-bucket"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
  default     = "terraform-lock"
}
