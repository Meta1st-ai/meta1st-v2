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

    schema {
      name = "address"          
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "city"             
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "country"          
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "job_title"        
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "object_id"        
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "state"            
      attribute_data_type = "String"
      mutable = true 
    }

    schema {
      name = "zip_code"         
      attribute_data_type = "String"
      mutable = true 
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
      ActiveEncryptionCertificate = "MIIC8DCCAdigAwIBAgIQT651FcxxK7xEz8D/wyv7ljANBgkqhkiG9w0BAQsFADA0MTIwMAYDVQQDEylNaWNyb3NvZnQgQXp1cmUgRmVkZXJhdGVkIFNTTyBDZXJ0aWZpY2F0ZTAeFw0yNTEwMDIwODA2NTdaFw0yODEwMDIwODA2NTdaMDQxMjAwBgNVBAMTKU1pY3Jvc29mdCBBenVyZSBGZWRlcmF0ZWQgU1NPIENlcnRpZmljYXRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq+NeXrrs80xwAwp0At7KEIbAF4wwb7U2qQlT9KYzwlCWkPu5c97AGvfV02nrOE1QxaQZXXA+6ImoArdb4g2pKoguTzUs9ID94tnq/s1x5qSPhLhmzw/m7psCKz+fa8+j1L+boIEwbBrPxuRO6HisJb1YTBof9IlbK6RgTSm8djqLG2PAzgLA7QG9sIyexfj40hfScZXfsIuGzaDkelMVkxSQN8tzA2NvY0tR8WHKGrfj66uNA5Ps59KtR0x3JILGsyNSZ9fJ0FulgkaZ5gqb/jEI/iEntUGNiDU0l4UnscLr/zvr/KqtNJwUWiJrxKXtrhloOWy0QKw0Ep2CVjvKWQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQACkJboQrpAOnSIchkGTTpCXgALn46enT+GnV6BOO/dRV1w9lNo8loiq7WzPXqrWYoEjoFKf9unflC4F5TGMhdqVa1k5oazcScu3rzYMHklPuMcEybkgcUsZ6n5D+8t57hh43OXJFx0zhQKok9ZfX9NdrwkE2TuLNjLUTbjtDe9ukxj1nrvBRA927pZQuBPoE8TYNq8dTy+PGhKzvUWBgUCVbTTr4SRWfnF/XGAQdK6gtO9rWLHBYra/uVCmTK1CrvPlGaKYpldNzcOQNpmsfOyqjHWVSn4DX5innF4eYtQaYr89pQ6eaX9JbIXByeS6sr25ZIPeumhjH4VByJ8Zuo0"
      SLORedirectBindingURI       = "https://login.microsoftonline.com/${var.azure_tenant_id}/saml2"
      SSORedirectBindingURI       = "https://login.microsoftonline.com/${var.azure_tenant_id}/saml2"
    }

    attribute_mapping = {
      email                = "email_address" #http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      given_name           = "given_name"   #"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
      family_name          = "family_name"    #"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
      name                 = "name"
      "custom:auth_method" = "sso"
      "custom:groups"      = "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
      "address"            = "address"
      "custom:city"        = "city"
      "custom:country"     = "country"
      "custom:department"  = "department"
      "custom:job_title"   = "job_title"
      "custom:object_id"   = "http://schemas.microsoft.com/identity/claims/objectidentifier"
      "custom:state"       = "state"
      "custom:zip_code"    = "zip_code"
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
      "http://localhost:8000/auth/sso/code/verify",
      "https://demoreviews.net/auth/sso/code/verify",

    ]
    logout_urls = [
      "http://localhost:8000/auth/login",
      "https://demoreviews.net/auth/login",
    ]
  
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
  