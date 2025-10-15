data "aws_region" "current" {}

resource "aws_cognito_user_pool" "user_pool_1" {
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
    name                = "department"
    mutable             = true
  }

  schema {
    attribute_data_type = "String"
    name                = "phone_number"
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

# Domain for User Pool 1
resource "aws_cognito_user_pool_domain" "user_pool_1_domain" {
  domain = lower(replace("${var.environment}-metafirst-${var.pool_name}-${random_string.domain_suffix.result}", "_", "-"))
  user_pool_id = aws_cognito_user_pool.user_pool_1.id
}

resource "random_string" "domain_suffix" {
  length  = 8
  special = false
  upper   = false
}

# App Client for  User Pool 1
resource "aws_cognito_user_pool_client" "user_pool_1_app_client" {
  name         = "${var.environment}-${var.pool_name}-Client"
  user_pool_id = aws_cognito_user_pool.user_pool_1.id

  generate_secret               = true
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows           = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
  supported_identity_providers  = ["COGNITO"]
}
