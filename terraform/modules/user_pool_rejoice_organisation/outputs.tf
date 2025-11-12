output "user_pool_id" {
    description = "user_pool_rejoice_organisation User Pool ID"
    value       = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.id
  }
  
  output "user_pool_arn" {
    description = "user_pool_rejoice_organisation User Pool ARN"
    value       = aws_cognito_user_pool.user_pool_rejoice_organisation_pool.arn
  }
  
  output "app_client_id" {
    description = "user_pool_rejoice_organisation App Client ID"
    value       = aws_cognito_user_pool_client.user_pool_rejoice_organisation_app_client.id
  }
  
  output "hosted_ui_domain" {
    description = "Hosted UI Domain for SAML"
    value       = "https://${aws_cognito_user_pool_domain.user_pool_rejoice_organisation_domain.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
  }
  