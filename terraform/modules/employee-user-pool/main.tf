data "aws_region" "current" {}

resource "aws_cognito_user_pool" "employee_pool" {
  name = var.pool_name

  username_configuration {
    case_sensitive = false
  }

  username_attributes = ["email"]

  password_policy {
    minimum_length                   = 12
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "given_name"
    required            = true
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "family_name"
    required            = true
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "organization_id"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "employee_id"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "department"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "auth_method"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "groups"
    mutable             = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  auto_verified_attributes = ["email"]

  lambda_config {
    pre_authentication  = var.pre_auth_lambda_arn
    post_authentication = var.post_auth_lambda_arn
    user_migration      = var.user_migration_lambda_arn
  }
}

# SAML Identity Provider for Azure AD
resource "aws_cognito_identity_provider" "azure_ad" {
  user_pool_id  = aws_cognito_user_pool.employee_pool.id
  provider_name = "AzureAD"
  provider_type = "SAML"

  provider_details = {
    MetadataURL = var.azure_metadata_url
  }

  attribute_mapping = {
    email                = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name           = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    family_name          = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
    "custom:auth_method" = "sso"
    "custom:groups"      = "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
  }
}

# App Client for Employee User Pool
resource "aws_cognito_user_pool_client" "employee_app_client" {
  name         = "MetaFirst-Employee-Client"
  user_pool_id = aws_cognito_user_pool.employee_pool.id

  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers  = ["COGNITO", "AzureAD"]

  callback_urls = ["https://example.com/callback"]
  logout_urls   = ["https://example.com/logout"]

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  allowed_oauth_flows_user_pool_client = true
}

# Domain for Hosted UI (required for SAML)
resource "aws_cognito_user_pool_domain" "employee_domain" {
  domain       = "metafirst-employees-${random_string.domain_suffix.result}"
  user_pool_id = aws_cognito_user_pool.employee_pool.id
}

resource "random_string" "domain_suffix" {
  length  = 8
  special = false
  upper   = false
}
