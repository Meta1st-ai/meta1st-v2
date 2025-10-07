variable "environment" {
  description = "Name of the environment"
  type        = string
  
}

variable "pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}

variable "pre_auth_lambda_arn" {
  description = "ARN of the pre-authentication Lambda function"
  type        = string
}

variable "post_auth_lambda_arn" {
  description = "ARN of the post-authentication Lambda function"
  type        = string
}

variable "user_migration_lambda_arn" {
  description = "ARN of the user migration Lambda function"
  type        = string
}
