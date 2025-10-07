variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
}

# Cognito user pool variables
variable "admin_user_pool_name" {
  description = "Name of the Admin Cognito User Pool"
  type        = string
}

variable "employee_user_pool_name" {
  description = "Name of the Employee Cognito User Pool"
  type        = string
}

# Cognito trigger lamba functions variables
variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_architecture" {
  description = "Lambda architecture"
  type        = string
  default     = "x86_64"
}


# Sync Cognito with Azure AD variables
variable "azure_metadata_url" {
  description = "Azure AD SAML metadata URL"
  type        = string
  default     = ""
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