variable "environment" {
  description = "Name of the environment"
  type        = string
  
}

variable "azure_tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure AD Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure AD Client Secret"
  type        = string
  sensitive   = true
}

variable "sync_lambda_runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "sync_lambda_architecture" {
  description = "Lambda architecture"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}
