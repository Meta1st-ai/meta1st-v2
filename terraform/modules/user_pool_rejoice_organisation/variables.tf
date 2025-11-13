variable "environment" {
    description = "Name of the environment"
    type        = string
  }
  
  variable "pool_name" {
    description = "Name of the Cognito User Pool"
    type        = string
  }
  
  variable "aws_region" {
    description = "AWS region"
    type        = string
  }
  
  variable "azure_metadata_url" {
    description = "Azure AD SAML metadata URL"
    type        = string
  }

  variable "active_encryption_certificate" {
    description = "Active encryption certificate"
    type        = string
  }
  
  variable "azure_tenant_id" {
    description = "Azure AD Tenant ID"
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
  