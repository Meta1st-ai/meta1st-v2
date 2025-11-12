data "aws_region" "current" {}
  
  resource "aws_cognito_user_pool" "user_pool_rejoice_organisation_pool" {
    name = "${var.environment}-${var.pool_name}"
  
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
  
    lifecycle {
      ignore_changes = [schema]
    }
  }
  
  # SAML Identity Provider for Azure AD
  resource "aws_cognito_identity_provider" "azure_ad" {
    user_pool_id  = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
    provider_name = "AzureAD"
    provider_type = "SAML"
  
    provider_details = {
      MetadataURL                 = var.azure_metadata_url
      ActiveEncryptionCertificate = "MIICvTCCAaWgAwIBAgIJAPJfivOcQJLaMA0GCSqGSIb3DQEBCwUAMB4xHDAaBgNVBAMME2V1LXdlc3QtMV9rMVV0OXpBcW0wHhcNMjUxMDE0MTIyMTUzWhcNMzUxMDE0MjIzMzUzWjAeMRwwGgYDVQQDDBNldS13ZXN0LTFfazFVdDl6QXFtMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArz+tWmULx3GSIiUDaOCld/IIVSJcAS0sYzzIN8sBSK7XivIDenD1VqpM3DQFQZ0ODNz8bG/9o7mCRss+MdeDbqHf9N2b5HYI3bFApqd/bBERktgxa9luGFZVqU+cxvO4jC1xv3jMjIgAKK5fCouxqmGTn+VdJ47Yq2lITvCcnfIEnQ+8wrtj/gHODN5c9lvBv0Kkswgh7j2d/UcAci1lJArrljxQVG41EeyWETPL9gnbFj9tR3vB8Pmwe+RYsDPxx8ocQEePziS08RG6Ia94Xq+8tFLKcUBspJJTeinOVzJmtWrxI7NqxtCpdttNW3yB68kps1pHNCfVYSZ991OaPQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBjfEmYJMefD3k0pY9Qp9rSZCG8N3KSLui6awk4akUr5TaMBAOmAlqIv82hPF63+kTNYXbv5krL+DpkRK+aYUefXTTCobhZQrGrrFbxotQ6u7cg5L+KLkaxkRjmVADGsASDRGNTUSgDPmjiD68GmKLAKlocFp+02YpLTfANrhEe5PiTdAvKpq9wuTr4ewWX+YR5xKn9dx7BLmZvdDKlfG4W0g/84x3/D0nR2Uu5e7P94srEs24Vwfz9kdzynlwseCzKba0WC4gzxAbEvtgFbhN1T2wtIHG2sgqXCC5oDonhsVHKQODSex/jrzEPLMI/wLqVky8+O5bqc7+JWPQ0qmd2"
      SLORedirectBindingURI       = "https://login.microsoftonline.com/${var.azure_tenant_id}/saml2"
      SSORedirectBindingURI       = "https://login.microsoftonline.com/${var.azure_tenant_id}/saml2"
    }
  
    attribute_mapping = {
      email                = "email_address"
      given_name           = "given_name"
      family_name          = "family_name"
      name                 = "name"
      "custom:auth_method" = "sso"
      "custom:groups"      = "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
    }
  }
  
  # App Client for user_pool_rejoice_organisation
  resource "aws_cognito_user_pool_client" "user_pool_rejoice_organisation_app_client" {
    name         = "${var.environment}-${var.pool_name}-Client"
    user_pool_id = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
  
    generate_secret               = true
    prevent_user_existence_errors = "ENABLED"
    explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
    supported_identity_providers  = ["COGNITO", "AzureAD"]
  
    callback_urls = [
      "https://example.com/callback",
      "https://jwt.io"
    ]
    logout_urls = ["https://example.com/logout"]
  
    allowed_oauth_flows                  = ["code"]
    allowed_oauth_scopes                 = ["email", "openid", "profile"]
    allowed_oauth_flows_user_pool_client = true
  }
  
  resource "aws_cognito_user_pool_domain" "user_pool_rejoice_organisation_domain" {
    domain       = lower(replace("${var.environment}-metafirst-${var.pool_name}-${random_string.domain_suffix.result}", "_", "-"))
    user_pool_id = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
  }
  
  resource "aws_cognito_user_group" "employee" {
    user_pool_id = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
    name         = "employee"
  }
  
  resource "aws_cognito_user_group" "admin" {
    user_pool_id = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
    name         = "admin"
  }
  
  resource "random_string" "domain_suffix" {
    length  = 8
    special = false
    upper   = false
  }
  