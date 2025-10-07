variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "account_id" {
  description = "AWS Account ID to make bucket name unique"
  type        = string
}
